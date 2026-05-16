// Reduz o delay de coleta a cada frame
if (collect_delay > 0) collect_delay--;

// Guarda posição atual no rastro e remove a mais antiga se necessário
ds_list_add(trail, { tx: x, ty: y });
if (ds_list_size(trail) > trail_max) ds_list_delete(trail, 0);

// Calcula velocidade atual — decresce linearmente conforme a distância restante
var _ratio         = 1 - (distance_traveled / max_distance);
var _current_speed = initial_speed * _ratio;

// Ricochete — inverte direção ao colidir com tile, sem alterar a velocidade
if (tilemap_get_at_pixel(tilemap, x + vx + 4, y) > 0 ||
    tilemap_get_at_pixel(tilemap, x + vx - 4, y) > 0) {
    vx = -vx;
}
if (tilemap_get_at_pixel(tilemap, x, y + vy + 4) > 0 ||
    tilemap_get_at_pixel(tilemap, x, y + vy - 4) > 0) {
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
    // Destroi inimigo
    instance_destroy(_inst_enemy);
    
    // --- NOVO: Sistema de Ricochete ---
    // Inverte a direção e adiciona um desvio aleatório (20 graus)
    var _dir_atual = point_direction(0, 0, vx, vy);
    var _nova_dir  = (_dir_atual + 180) + irandom_range(-20, 20);
    
    // Mantém a velocidade mas reduz um pouco (impacto)
    var _nova_spd = initial_speed * 0.7; // Perde 30% da força original no impacto
    initial_speed = _nova_spd;
    
    vx = lengthdir_x(_nova_spd, _nova_dir);
    vy = lengthdir_y(_nova_spd, _nova_dir);
    
    // "Dá mais vida" para a bolinha continuar voando após o ricochete
    // Reduzimos a distância percorrida para que ela tenha fôlego para o rebote
    distance_traveled = max(0, distance_traveled - (max_distance * 0.3));
}

// Coleta automática ao jogador passar por cima (só após o delay)
if (collect_delay <= 0 && instance_exists(owner)) {
    if (point_distance(x, y, owner.x, owner.y) < 16) {
        owner.ball.on_ball_collected();
    }
}