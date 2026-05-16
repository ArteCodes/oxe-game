/// @description Sistema de IA para o inimigo de longa distância (Krab Blue)
/// @param {real} _move_spd Velocidade de movimento
/// @param {real} _shoot_delay Intervalo entre tiros (frames)
/// @param {asset} _spr_idle Sprite parado
/// @param {asset} _spr_walk Sprite andando
function EnemyLongAiSystem(_move_spd, _shoot_delay, _spr_idle, _spr_walk) constructor {
    move_speed  = _move_spd;
    shoot_delay = _shoot_delay; // Aumentaremos este valor no Create do objeto
    spr_idle    = _spr_idle;
    spr_walk    = _spr_walk;

    shoot_timer = 0;
    
    // Configurações de Range
    range_ideal  = 180; // Distância que ele tenta manter
    range_buffer = 40;  // Margem para não ficar "tremendo"
    range_max    = 300; // Se estiver além disso, ele corre para alcançar

    static update = function(_inst) {
        var _player = obj_player;
        
        if (!instance_exists(_player)) {
            _inst.sprite_index = spr_idle;
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            return;
        }

        // --- 1. LÓGICA DE MORTE (Igual ao inimigo padrão) ---
        with (_inst) {
            var _ball = instance_place(x, y, obj_ball);
            if (_ball != noone && (abs(_ball.vx) > 0.5 || abs(_ball.vy) > 0.5)) {
                instance_destroy(); 
                return;
            }
        }

        var _dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
        var _dir  = point_direction(_inst.x, _inst.y, _player.x, _player.y);

        // --- 2. MOVIMENTAÇÃO (Manter distância direta) ---
        if (_dist > range_max) {
            // Fora do alcance máximo: Perseguir direto
            _inst.movement.vx = lengthdir_x(move_speed, _dir);
            _inst.movement.vy = lengthdir_y(move_speed, _dir);
            _inst.sprite_index = spr_walk;
        } 
        else if (_dist < range_ideal - range_buffer) {
            // Perto demais: Fugir direto
            _inst.movement.vx = lengthdir_x(move_speed, _dir + 180);
            _inst.movement.vy = lengthdir_y(move_speed, _dir + 180);
            _inst.sprite_index = spr_walk;
        }
        else if (_dist > range_ideal + range_buffer) {
            // Longe demais do ideal: Aproximar suavemente direto
            _inst.movement.vx = lengthdir_x(move_speed * 0.8, _dir);
            _inst.movement.vy = lengthdir_y(move_speed * 0.8, _dir);
            _inst.sprite_index = spr_walk;
        }
        else {
            // No range ideal: Parar
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            _inst.sprite_index = spr_idle;
        }

        // Direção visual
        _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;

        // --- 3. ATAQUE (Bolhas) ---
        shoot_timer++;
        
        // Mira (indicador visual de onde ele vai atirar)
        // Mostra a mira quando estiver quase atirando (ex: últimos 45 frames)
        if (shoot_timer > shoot_delay - 45) {
            var _target_dist = point_distance(_inst.x, _inst.y - 8, _player.x, _player.y - 12);
            var _dir_aim = point_direction(_inst.x, _inst.y - 8, _player.x, _player.y - 12);
            _inst.aim_x = _inst.x + lengthdir_x(_target_dist, _dir_aim);
            _inst.aim_y = (_inst.y - 8) + lengthdir_y(_target_dist, _dir_aim);
            _inst.draw_aim = true;
            _inst.aim_color = c_white; // Voltando para branco/claro para ser mais discreto
        } else {
            _inst.draw_aim = false;
        }

        if (shoot_timer >= shoot_delay) {
            shoot_timer = 0;
            // Spawna a bolha com um pequeno offset para frente (evita colidir com parede onde o caranguejo está encostado)
            var _b_dir = point_direction(_inst.x, _inst.y - 8, _player.x, _player.y - 12);
            var _bx = _inst.x + lengthdir_x(16, _b_dir);
            var _by = (_inst.y - 8) + lengthdir_y(16, _b_dir);
            
            var _bubble = instance_create_layer(_bx, _by, "Instances", obj_bubble);
            _bubble.vx = lengthdir_x(4, _b_dir);
            _bubble.vy = lengthdir_y(4, _b_dir);
        }

        // --- SEPARAÇÃO (Evita amontoar) ---
        with (obj_enemy_parent) {
            if (id != _inst) {
                var _sep_dist = point_distance(_inst.x, _inst.y, x, y);
                if (_sep_dist < 28) {
                    var _pdir = point_direction(x, y, _inst.x, _inst.y);
                    var _push = (28 - _sep_dist) * 0.15; // Empurrão proporcional
                    _inst.movement.vx += lengthdir_x(_push, _pdir);
                    _inst.movement.vy += lengthdir_y(_push, _pdir);
                }
            }
        }

        // --- 4. DANO AO TOCAR ---
        with (_inst) {
            var _p_hit = instance_place(x, y, obj_player);
            if (_p_hit != noone) {
                _p_hit.hp.take_damage(x, y, _p_hit.x, _p_hit.y);
            }
        }
    }
}
