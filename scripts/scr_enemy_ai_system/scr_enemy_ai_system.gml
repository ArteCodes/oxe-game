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
    vision_range    = 320; // Campo de visão (distância máxima para perseguir/atacar)

    // Variáveis de Estado Internas
    state    = "waiting"; // Estados: "waiting", "follow", "charging", "dashing", "melee"
    timer    = 0;
    wait_time = 60; // Tempo de espera inicial (1 segundo)
    dash_dir = 0;
    melee_range = 28; // Distância para ativar o golpe de garra
    melee_active = false; // Controla a exibição do efeito de corte
    melee_preparing = false; // Indica se está preparando o golpe
    melee_cooldown = 0; // Timer do cooldown
    melee_cooldown_max = 90; // Tempo entre ataques (1.5 segundos)

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
                            return; // Interrompe a execução modular
                        }
                    }
                }
                
            }
        }

        // --- REDUÇÃO DE COOLDOWN ---
        if (melee_cooldown > 0) melee_cooldown--;

        // --- 2. MÁQUINA DE ESTADOS ---
        var _is_attacking = (state == "charging" || state == "dashing" || state == "melee");
        
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

                // Segue o jogador diretamente (como antes)
                var _dir = point_direction(_inst.x, _inst.y, _player.x, _player.y);
                _inst.movement.vx = lengthdir_x(follow_speed, _dir);
                _inst.movement.vy = lengthdir_y(follow_speed, _dir);
                
                // Animação e Direção Visual
                _inst.sprite_index = spr_walk;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;

                // --- NOVO: Checa distância para ataque corpo a corpo ---
                var _dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                if (_dist < melee_range && melee_cooldown == 0) {
                    state = "melee";
                    timer = 0;
                    melee_active = false; // Não ativa o corte ainda
                    melee_preparing = true; // Ativa indicador de "carregando golpe"
                    melee_cooldown = melee_cooldown_max; 
                }

                // Timer para iniciar a investida (dash) se não estiver perto o suficiente para melee
                timer++;
                if (timer >= 120) {
                    state = "charging";
                    timer = 0;
                    dash_dir = _dir;
                }
                break;

            case "melee":
                // Fica parado durante o ataque
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                if (sprite_exists(spr_crab_attack)) {
                    _inst.sprite_index = spr_crab_attack;
                    _inst.image_speed = 0.25; // Velocidade da garra atacando
                } else {
                    _inst.sprite_index = spr_idle;
                }
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;
                
                timer++;
                
                // 1. Fase de Preparação (20 frames)
                if (timer == 20) {
                    melee_preparing = false;
                    melee_active = true;
                    
                    // Só aplica o dano se o jogador AINDA estiver por perto (range de impacto)
                    if (instance_exists(_player)) {
                        var _impact_dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                        if (_impact_dist < melee_range + 12) {
                            _player.hp.take_damage(_inst.x, _inst.y, _player.x, _player.y);
                        }
                    }
                }
                
                // 2. Fase Ativa do Corte (15 frames após a preparação)
                if (timer >= 35) {
                    melee_active = false;
                }
                
                // 3. Fim do Estado (Recuperação)
                if (timer >= 50) {
                    state = "follow";
                    _inst.image_speed = 1.0; // Restaura velocidade de animação padrão
                    timer = 0;
                }
                break;

            case "charging":
                if (sprite_exists(spr_crab_attack)) {
                    _inst.sprite_index = spr_crab_attack;
                    _inst.image_speed = 0.15; // Prepara o ataque de forma lenta
                } else {
                    _inst.sprite_index = spr_idle;
                }
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                timer++;
                if (timer >= 60) {
                    state = "dashing";
                    timer = 0;
                }
                break;

            case "dashing":
                if (sprite_exists(spr_crab_attack)) {
                    _inst.sprite_index = spr_crab_attack;
                    _inst.image_speed = 0.45; // Animação rápida de avanço
                }
                _inst.image_xscale = (lengthdir_x(1, dash_dir) < 0) ? -1 : 1;
                _inst.movement.vx = lengthdir_x(dash_speed, dash_dir);
                _inst.movement.vy = lengthdir_y(dash_speed, dash_dir);
                
                // --- NOVO: Dano durante a investida (dash) ---
                with (_inst) {
                    var _p_hit = instance_place(x, y, obj_player);
                    if (_p_hit != noone) {
                        _p_hit.hp.take_damage(x, y, _p_hit.x, _p_hit.y);
                        other.state = "follow";
                        _inst.image_speed = 1.0; // Restaura velocidade de animação padrão
                        other.timer = 0;
                    }
                }

                timer++;
                if (timer >= 25) {
                    state = "follow";
                    _inst.image_speed = 1.0; // Restaura velocidade de animação padrão
                    timer = 0;
                }
                break;
        }

        // --- SEPARAÇÃO (Só se não estiver atacando e já tiver acordado) ---
        if (!_is_attacking && state != "waiting") {
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