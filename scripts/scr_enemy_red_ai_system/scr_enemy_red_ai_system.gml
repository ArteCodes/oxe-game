/// @description Sistema de IA para o inimigo vermelho (comportamento igual ao inimigo normal, mas explode por proximidade)
/// @param {real} _follow_spd Velocidade normal
/// @param {real} _dash_spd Velocidade da investida
/// @param {asset} _spr_idle Sprite parado
/// @param {asset} _spr_walk Sprite andando
/// @param {asset} _spr_attack Sprite de ataque/explosão
function EnemyRedAiSystem(_follow_spd, _dash_spd, _spr_idle, _spr_walk, _spr_attack) constructor {
    // Variáveis de Configuração
    follow_speed    = _follow_spd;
    dash_speed      = _dash_spd;
    spr_idle        = _spr_idle;
    spr_walk        = _spr_walk;
    spr_attack      = _spr_attack;
    vision_range    = 320; // Campo de visão (distância máxima para perseguir/atacar)

    // Variáveis de Estado Internas
    state    = "waiting"; // Estados: "waiting", "follow", "charging", "dashing", "exploding"
    timer    = 0;
    wait_time = 30; // Tempo de espera inicial antes de começar a perseguir
    dash_dir = 0;
    explosion_range = 48; // Raio da explosão
    explosion_trigger_range = 32; // Distância para iniciar a explosão
    explosion_timer_max = 30; // Frames antes da explosão após iniciar o estado
    explosion_warning = false;
    explosion_circle_alpha = 0;

    static update = function(_inst) {
        var _player = obj_player;

        if (!instance_exists(_player)) {
            _inst.sprite_index = spr_idle;
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            return;
        }

        // --- 1. LÓGICA DE MORTE (Colisão com obj_ball) ---
        with (_inst) {
            var _ball = instance_place(x, y, obj_ball);
            if (_ball != noone) {
                if (abs(_ball.vx) > 0.5 || abs(_ball.vy) > 0.5) {
                    var _has_cooldown = variable_instance_exists(self, "hit_cooldown");
                    var _can_damage = !_has_cooldown || (hit_cooldown <= 0);
                    if (_can_damage) {
                        if (!variable_instance_exists(self, "hp")) {
                            hp = 3;
                        }
                        hp -= 1;
                        hit_cooldown = 20;
                        if (hp <= 0) {
                            instance_destroy();
                            return;
                        }
                    }
                }
            }
        }

        // --- 2. MÁQUINA DE ESTADOS ---
        switch (state) {
            case "waiting":
                _inst.sprite_index = spr_idle;
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                
                var _dist_wait = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                if (_dist_wait <= vision_range) {
                    state = "follow";
                    timer = 0;
                }
                break;

            case "follow":
                var _dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                
                // Se o player estiver fora do campo de visão, volta a ficar imóvel em waiting
                if (_dist > vision_range) {
                    state = "waiting";
                    timer = 0;
                    break;
                }

                var _dir = point_direction(_inst.x, _inst.y, _player.x, _player.y);
                _inst.movement.vx = lengthdir_x(follow_speed, _dir);
                _inst.movement.vy = lengthdir_y(follow_speed, _dir);
                _inst.sprite_index = spr_walk;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;

                if (_dist < explosion_trigger_range) {
                    state = "exploding";
                    timer = 0;
                    explosion_warning = true;
                    explosion_circle_alpha = 0;
                    break;
                }

                timer++;
                if (timer >= 60) {
                    state = "charging";
                    timer = 0;
                    dash_dir = _dir;
                }
                break;

            case "charging":
                _inst.sprite_index = spr_walk;
                _inst.image_speed = 0.25;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                timer++;
                if (timer >= 30) {
                    state = "dashing";
                    timer = 0;
                }
                break;

            case "dashing":
                // Usa sprite de corrida para a investida, não o sprite de morte/explosão
                _inst.sprite_index = spr_walk;
                _inst.image_speed = 1.0;
                _inst.image_xscale = (lengthdir_x(1, dash_dir) < 0) ? -1 : 1;
                _inst.movement.vx = lengthdir_x(dash_speed, dash_dir);
                _inst.movement.vy = lengthdir_y(dash_speed, dash_dir);

                var _dist_hit = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                timer++;
                if (_dist_hit < explosion_trigger_range) {
                    state = "exploding";
                    timer = 0;
                    explosion_warning = true;
                    explosion_circle_alpha = 0;
                    _inst.movement.vx = 0;
                    _inst.movement.vy = 0;
                } else if (timer >= 25) {
                    state = "follow";
                    timer = 0;
                }
                break;

            case "exploding":
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                if (sprite_exists(spr_attack)) {
                    _inst.sprite_index = spr_attack;
                    _inst.image_speed = 0.3;
                } else {
                    _inst.sprite_index = spr_idle;
                }
                timer++;
                var _progress = timer / explosion_timer_max;
                explosion_circle_alpha = _progress * 0.6;
                if (timer mod 4 < 2) {
                    _inst.image_blend = c_red;
                } else {
                    _inst.image_blend = c_white;
                }
                if (timer >= explosion_timer_max) {
                    explosion_warning = false;
                    if (instance_exists(_player)) {
                        var _impact_dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                        if (_impact_dist < explosion_range) {
                            _player.hp.hearts = 0;
                            _player.hp.dead = true;
                        }
                    }
                    effect_create_above(ef_ring, _inst.x, _inst.y, 1, c_red);
                    effect_create_above(ef_smoke, _inst.x, _inst.y, 1, c_orange);
                    effect_create_above(ef_smoke, _inst.x, _inst.y, 0, c_white);
                    with (_inst) {
                        instance_destroy();
                    }
                    return;
                }
                break;
        }

        // --- SEPARAÇÃO (Só se não estiver explodindo e estiver acordado) ---
        if (state != "exploding" && state != "waiting") {
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
    }
}
