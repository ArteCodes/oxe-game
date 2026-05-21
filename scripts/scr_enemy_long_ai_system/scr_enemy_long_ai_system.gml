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
    vision_range = 400; // Maior campo de visão de todos
    
    // Variáveis de Estado
    state      = "waiting"; // Estados: "waiting", "active"
    timer      = 0;
    wait_time  = 60; // 1 segundo de espera
    aim_dir    = 0;
    
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
                var _has_cooldown = variable_instance_exists(self, "hit_cooldown");
                var _can_damage = !_has_cooldown || (hit_cooldown <= 0);
                
                if (_can_damage) {
                    if (!variable_instance_exists(self, "hp")) {
                        hp = 1;
                    }
                    hp -= 1;
                    hit_cooldown = 20; // 20 frames de imunidade (0.33 segundos)
                    
                    if (hp <= 0) {
                        instance_destroy(); 
                        return;
                    }
                }
            }
        }

        var _dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
        var _dir  = point_direction(_inst.x, _inst.y, _player.x, _player.y);

        // --- MÁQUINA DE ESTADOS SIMPLES ---
        if (state == "waiting") {
            _inst.sprite_index = spr_idle;
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            
            var _dist_wait = point_distance(_inst.x, _inst.y, _player.x, _player.y);
            if (_dist_wait <= vision_range) {
                state = "active";
                timer = 0;
            }
            return; // Sai do update enquanto espera
        }

        // Se o player estiver fora do campo de visão, volta para waiting
        if (_dist > vision_range) {
            state = "waiting";
            shoot_timer = 0;
            _inst.draw_aim = false;
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            _inst.sprite_index = spr_idle;
            return;
        }

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
        if (shoot_timer > shoot_delay - 45) {
            // Atualiza a direção continuamente (seguindo o jogador)
            aim_dir = point_direction(_inst.x, _inst.y - 8, _player.x, _player.y - 12);
            
            var _fixed_dist = 200; // Comprimento fixo da mira (igual ao normal)
            _inst.aim_x = _inst.x + lengthdir_x(_fixed_dist, aim_dir);
            _inst.aim_y = (_inst.y - 8) + lengthdir_y(_fixed_dist, aim_dir);
            _inst.draw_aim = true;
            _inst.aim_color = c_white; 
        } else {
            _inst.draw_aim = false;
        }

        if (shoot_timer >= shoot_delay) {
            shoot_timer = 0;
            // Recalcula a direção final para o tiro no momento do disparo
            var _b_dir = point_direction(_inst.x, _inst.y - 8, _player.x, _player.y - 12);
            var _bx = _inst.x + lengthdir_x(16, _b_dir);
            var _by = (_inst.y - 8) + lengthdir_y(16, _b_dir);
            
            var _bubble = safe_create_layer(_bx, _by, "Instances", obj_bubble);
            _bubble.vx = lengthdir_x(4, _b_dir);
            _bubble.vy = lengthdir_y(4, _b_dir);
        }

        // --- SEPARAÇÃO (Evita amontoar - Só ativa se estiver acordado) ---
        if (state != "waiting") {
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
        }

    }
}
