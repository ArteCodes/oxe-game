/// @description Sistema de IA para inimigos (Seguir, Carregar e Investir)
/// @param {real} _follow_spd Velocidade normal
/// @param {real} _dash_spd Velocidade da investida
/// @param {asset} _spr_idle Sprite parado
/// @param {asset} _spr_walk Sprite andando
function EnemyAiSystem(_follow_spd, _dash_spd, _spr_idle, _spr_walk) constructor {
    // Variáveis de Configuração
    follow_speed    = _follow_spd;
    dash_speed      = _dash_spd;
    spr_idle        = _spr_idle;
    spr_walk        = _spr_walk;
    trail_thickness = 4; // Grossura do rastro visual

    // Variáveis de Estado Internas
    state    = "follow"; // Estados: "follow", "charging", "dashing"
    timer    = 0;
    dash_dir = 0;

    static update = function(_inst) {
        var _player = obj_player;
        
        // Verificação de segurança: se o player não existe, fica parado
        if (!instance_exists(_player)) {
            _inst.sprite_index = spr_idle;
            // Zera a velocidade se o jogador sumir
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            return;
        }

          // --- 1. LÓGICA DE MORTE (Colisão com obj_ball) ---
        with (_inst) {
            // Guarda a ID do obj_ball com o qual o caranguejo encostou
            var _ball = instance_place(x, y, obj_ball);
            
            // Se de fato ele encostou em um obj_ball
            if (_ball != noone) {
                
                // VERIFICAÇÃO DE IMPACTO USANDO AS VARIÁVEIS DIRETAS DA BOLA
                if (abs(_ball.vx) > 0.5 || abs(_ball.vy) > 0.5) {
                    instance_destroy(); 
                    return; // Interrompe a execução modular
                }
                
            }
        }

        // --- 2. MÁQUINA DE ESTADOS ---
        var _is_attacking = (state == "charging" || state == "dashing");
        
        switch (state) {
            case "follow":
                // Segue o jogador diretamente (como antes)
                var _dir = point_direction(_inst.x, _inst.y, _player.x, _player.y);
                _inst.movement.vx = lengthdir_x(follow_speed, _dir);
                _inst.movement.vy = lengthdir_y(follow_speed, _dir);
                
                // Animação e Direção Visual
                _inst.sprite_index = spr_walk;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;

                // Timer para iniciar a investida
                timer++;
                if (timer >= 120) {
                    state = "charging";
                    timer = 0;
                    dash_dir = _dir;
                }
                break;

            case "charging":
                _inst.sprite_index = spr_idle;
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                timer++;
                if (timer >= 60) {
                    state = "dashing";
                    timer = 0;
                }
                break;

            case "dashing":
                _inst.movement.vx = lengthdir_x(dash_speed, dash_dir);
                _inst.movement.vy = lengthdir_y(dash_speed, dash_dir);
                timer++;
                if (timer >= 25) {
                    state = "follow";
                    timer = 0;
                }
                break;
        }

        // --- SEPARAÇÃO (Só se não estiver atacando) ---
        if (!_is_attacking) {
            with (obj_enemy_parent) {
                if (id != _inst) {
                    var _sep_dist = point_distance(_inst.x, _inst.y, x, y);
                    if (_sep_dist < 24) {
                        var _pdir = point_direction(x, y, _inst.x, _inst.y);
                        var _push = (24 - _sep_dist) * 0.1;
                        _inst.movement.vx += lengthdir_x(_push, _pdir);
                        _inst.movement.vy += lengthdir_y(_push, _pdir);
                    }
                }
            }
        }

        // --- 3. DANO AO JOGADOR (Integração com HealthSystem) ---
        with (_inst) {
            var _p_hit = instance_place(x, y, obj_player);
            if (_p_hit != noone) {
                // Chama o método take_damage do HealthSystem do player
                // Passa a fonte do dano (x, y) e a posição do player (x, y)
                _p_hit.hp.take_damage(x, y, _p_hit.x, _p_hit.y);
            }
        }
    }
}