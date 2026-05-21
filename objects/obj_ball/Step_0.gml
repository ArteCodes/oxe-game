// Reduz o delay de coleta a cada frame
if (collect_delay > 0) collect_delay--;

// Guarda posição atual no rastro e remove a mais antiga se necessário
ds_list_add(trail, { tx: x, ty: y });
if (ds_list_size(trail) > trail_max) ds_list_delete(trail, 0);

// Calcula velocidade atual — decresce linearmente conforme a distância restante
var _ratio         = 1 - (distance_traveled / max_distance);
var _current_speed = initial_speed * _ratio;

// Ricochete — inverte direção ao colidir com tile ou porta fechada, sem alterar a velocidade
var _collide_x = false;
if (tilemap_get_at_pixel(tilemap, x + vx + 4, y) > 0 ||
    tilemap_get_at_pixel(tilemap, x + vx - 4, y) > 0) {
    _collide_x = true;
} else {
    // Portas normais / do boss
    var _door_x1 = instance_place(x + vx + 4, y, obj_wall_door);
    var _door_x2 = instance_place(x + vx - 4, y, obj_wall_door);
    if ((_door_x1 != noone && (_door_x1.door_sys == undefined || !_door_x1.door_sys.is_opening)) ||
        (_door_x2 != noone && (_door_x2.door_sys == undefined || !_door_x2.door_sys.is_opening))) {
        _collide_x = true;
    } else {
        // Portas de pedra
        var _sdoor_x1 = instance_place(x + vx + 4, y, obj_stone_door);
        var _sdoor_x2 = instance_place(x + vx - 4, y, obj_stone_door);
        if ((_sdoor_x1 != noone && (_sdoor_x1.x == _sdoor_x1.x_start && _sdoor_x1.y == _sdoor_x1.y_start)) ||
            (_sdoor_x2 != noone && (_sdoor_x2.x == _sdoor_x2.x_start && _sdoor_x2.y == _sdoor_x2.y_start))) {
            _collide_x = true;
        }
    }
}
if (_collide_x) {
    vx = -vx;
}

var _collide_y = false;
if (tilemap_get_at_pixel(tilemap, x, y + vy + 4) > 0 ||
    tilemap_get_at_pixel(tilemap, x, y + vy - 4) > 0) {
    _collide_y = true;
} else {
    // Portas normais / do boss
    var _door_y1 = instance_place(x, y + vy + 4, obj_wall_door);
    var _door_y2 = instance_place(x, y + vy - 4, obj_wall_door);
    if ((_door_y1 != noone && (_door_y1.door_sys == undefined || !_door_y1.door_sys.is_opening)) ||
        (_door_y2 != noone && (_door_y2.door_sys == undefined || !_door_y2.door_sys.is_opening))) {
        _collide_y = true;
    } else {
        // Portas de pedra
        var _sdoor_y1 = instance_place(x, y + vy + 4, obj_stone_door);
        var _sdoor_y2 = instance_place(x, y + vy - 4, obj_stone_door);
        if ((_sdoor_y1 != noone && (_sdoor_y1.x == _sdoor_y1.x_start && _sdoor_y1.y == _sdoor_y1.y_start)) ||
            (_sdoor_y2 != noone && (_sdoor_y2.x == _sdoor_y2.x_start && _sdoor_y2.y == _sdoor_y2.y_start))) {
            _collide_y = true;
        }
    }
}
if (_collide_y) {
    vy = -vy;
}

// Mantém a direção atual e aplica a velocidade calculada pela distância
var _dir = point_direction(0, 0, vx, vy);
if (vx != 0 || vy != 0) {
    vx = lengthdir_x(_current_speed, _dir);
    vy = lengthdir_y(_current_speed, _dir);
}

// Aplica movimento
x += vx;
y += vy;
distance_traveled += _current_speed;

// Para a bolinha ao atingir o alcance máximo e avisa o BallSystem
if (distance_traveled >= max_distance) {
    vx = 0;
    vy = 0;
    if (instance_exists(owner)) owner.ball.on_ball_stopped(id);
}

// Acerta inimigo — some em fumaca
var _inst_enemy = instance_place(x, y, obj_enemy_parent);

// Fallback: Se não detectou por máscara, tenta por distância curta
if (_inst_enemy == noone) {
    var _nearest = instance_nearest(x, y, obj_enemy_parent);
    if (_nearest != noone && point_distance(x, y, _nearest.x, _nearest.y) < 24) _inst_enemy = _nearest;
}

if (_inst_enemy != noone && (abs(vx) > 0.5 || abs(vy) > 0.5)) {
    var _has_cooldown = variable_instance_exists(_inst_enemy, "hit_cooldown");
    var _can_damage = !_has_cooldown || (_inst_enemy.hit_cooldown <= 0);
    
    if (_can_damage) {
        if (!variable_instance_exists(_inst_enemy, "hp")) {
            _inst_enemy.hp = 1;
        }
        _inst_enemy.hp -= 1;
        
        // Cooldown de imunidade diferenciado para o Boss
        var _cooldown_time = 20;
        if (_inst_enemy.object_index == obj_boss) {
            _cooldown_time = 60; // 60 frames (1 segundo) para o Boss
        }
        _inst_enemy.hit_cooldown = _cooldown_time;
        
        // Salva propriedades importantes antes de destruir a instância para evitar crash de acesso
        var _enemy_x   = _inst_enemy.x;
        var _enemy_y   = _inst_enemy.y;
        var _enemy_obj = _inst_enemy.object_index;
        
        if (_inst_enemy.hp <= 0) {
            instance_destroy(_inst_enemy);
        }
        
        // --- NOVO: Sistema de Ricochete Radial & Evasão ---
        // Calcula a direção de repulsão a partir do centro do inimigo
        var _push_dir = point_direction(_enemy_x, _enemy_y, x, y);
        var _nova_dir = _push_dir + irandom_range(-15, 15);
        
        // Evita que a bolinha fique presa dentro do colisor do inimigo
        if (_enemy_obj == obj_boss) {
            var _boss_radius = 58; // Metade do tamanho do boss (64 * 1.8 / 2 = 57.6)
            var _target_push_dist = _boss_radius + 16;
            
            // Verifica colisões com paredes antes de empurrar para não prender a bolinha nelas
            var _safe_dist = _target_push_dist;
            while (_safe_dist > 16) {
                var _test_x = _enemy_x + lengthdir_x(_safe_dist, _push_dir);
                var _test_y = _enemy_y + lengthdir_y(_safe_dist, _push_dir);
                if (tilemap_get_at_pixel(tilemap, _test_x, _test_y) == 0) {
                    x = _test_x;
                    y = _test_y;
                    break;
                }
                _safe_dist -= 4; // Tenta uma distância menor se colidir
            }
        } else {
            // Inimigos normais: empurra levemente para fora
            var _push_x = x + lengthdir_x(8, _push_dir);
            var _push_y = y + lengthdir_y(8, _push_dir);
            if (tilemap_get_at_pixel(tilemap, _push_x, _push_y) == 0) {
                x = _push_x;
                y = _push_y;
            }
        }
        
        // Mantém a velocidade mas reduz um pouco (impacto)
        var _nova_spd = initial_speed * 0.7; // Perde 30% da força original no impacto
        initial_speed = _nova_spd;
        
        vx = lengthdir_x(_nova_spd, _nova_dir);
        vy = lengthdir_y(_nova_spd, _nova_dir);
        
        // "Dá mais vida" para a bolinha continuar voando após o ricochete
        // Reduzimos a distância percorrida para que ela tenha fôlego para o rebote
        distance_traveled = max(0, distance_traveled - (max_distance * 0.3));
    }
}

// Coleta automática ao jogador passar por cima (só após o delay)
if (collect_delay <= 0 && instance_exists(owner)) {
    if (point_distance(x, y, owner.x, owner.y) < 16) {
        owner.ball.on_ball_collected();
    }
}