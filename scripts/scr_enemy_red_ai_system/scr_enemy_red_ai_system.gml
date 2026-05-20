/// @description Sistema de IA para o inimigo vermelho (Kamikaze Explosivo)
/// @param {real} _follow_spd Velocidade de perseguição
/// @param {asset} _spr_idle Sprite parado
/// @param {asset} _spr_walk Sprite andando
/// @param {asset} _spr_attack Sprite de ataque (usado ao explodir)
function EnemyRedAiSystem(_follow_spd, _spr_idle, _spr_walk, _spr_attack) constructor {
    // Variáveis de Configuração
    follow_speed    = _follow_spd;
    spr_idle        = _spr_idle;
    spr_walk        = _spr_walk;
    spr_attack      = _spr_attack;

    // Variáveis de Estado Internas
    state    = "waiting"; // Estados: "waiting", "follow", "exploding"
    timer    = 0;
    wait_time = 40; // Tempo de espera inicial (menor que o normal — mais agressivo)
    
    // Explosão
    explosion_range = 48; // Raio da explosão (área de dano)
    explosion_trigger_range = 32; // Distância para iniciar a explosão
    explosion_timer_max = 45; // Tempo até explodir após ativar (0.75 segundos)
    explosion_warning = false; // Se está no modo "vai explodir"
    explosion_circle_alpha = 0; // Alpha do círculo de aviso

    static update = function(_inst) {
        var _player = obj_player;
        
        // Verificação de segurança: se o player não existe, fica parado
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
                
                timer++;
                if (timer >= wait_time) {
                    state = "follow";
                    timer = 0;
                }
                break;

            case "follow":
                // Corre diretamente para cima do jogador — AGRESSIVO
                var _dir = point_direction(_inst.x, _inst.y, _player.x, _player.y);
                var _spd = follow_speed;
                
                // Seta a velocidade diretamente (sem usar aceleração do movement.move)
                _inst.movement.vx = lengthdir_x(_spd, _dir);
                _inst.movement.vy = lengthdir_y(_spd, _dir);
                
                // Animação e Direção Visual
                _inst.sprite_index = spr_walk;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;

                // Checa distância para ativar a explosão
                var _dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                if (_dist < explosion_trigger_range) {
                    state = "exploding";
                    timer = 0;
                    explosion_warning = true;
                    explosion_circle_alpha = 0;
                }
                break;

            case "exploding":
                // Fica parado, pulsando, prestes a explodir!
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                
                if (sprite_exists(spr_attack)) {
                    _inst.sprite_index = spr_attack;
                    _inst.image_speed = 0.3;
                } else {
                    _inst.sprite_index = spr_idle;
                }
                
                timer++;
                
                // Pulsa o alpha do círculo de aviso (cresce conforme se aproxima da explosão)
                var _progress = timer / explosion_timer_max;
                explosion_circle_alpha = _progress * 0.6;
                
                // Pulsa o caranguejo (pisca rápido pra indicar que vai explodir)
                if (timer mod 4 < 2) {
                    _inst.image_blend = c_red;
                } else {
                    _inst.image_blend = c_white;
                }
                
                // EXPLODE!
                if (timer >= explosion_timer_max) {
                    explosion_warning = false;
                    
                    // HITKILL: Mata o jogador instantaneamente se estiver dentro do raio
                    if (instance_exists(_player)) {
                        var _impact_dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                        if (_impact_dist < explosion_range) {
                            // Zera todos os corações — morte instantânea!
                            _player.hp.hearts = 0;
                            _player.hp.dead = true;
                        }
                    }
                    
                    // Efeitos visuais da explosão
                    effect_create_above(ef_ring, _inst.x, _inst.y, 1, c_red);
                    effect_create_above(ef_smoke, _inst.x, _inst.y, 1, c_orange);
                    effect_create_above(ef_smoke, _inst.x, _inst.y, 0, c_white);
                    
                    // O caranguejo se autodestrói na explosão
                    with (_inst) {
                        instance_destroy();
                    }
                    return;
                }
                break;
        }

        // --- SEPARAÇÃO (Só quando seguindo) ---
        if (state == "follow") {
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
