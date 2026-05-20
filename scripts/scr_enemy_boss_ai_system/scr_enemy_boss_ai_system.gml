/// @description Sistema de IA para o Boss Caranguejo (EnemyBossAiSystem)
/// @param {real} _follow_spd Velocidade normal de perseguição
/// @param {real} _dash_spd Velocidade do dash
/// @param {asset} _spr_idle Sprite parado / andando
/// @param {asset} _spr_attack Sprite de ataque (garras)
function EnemyBossAiSystem(_follow_spd, _dash_spd, _spr_idle, _spr_attack) constructor {
    // Variáveis de Configuração
    follow_speed = _follow_spd;
    dash_speed   = _dash_spd;
    spr_idle     = _spr_idle;
    spr_attack   = _spr_attack;
    vision_range = 450; // Campo de visão amplo do boss

    // Variáveis de Estado Internas
    state = "waiting"; // Estados: "waiting", "chase", "prepare_melee", "melee", "prepare_dash", "dashing", "prepare_spawn", "spawn", "prepare_spike", "spike"
    timer = 0;
    
    // Cooldown de ataques gerais
    attack_cooldown = 120; // Tempo inicial livre antes de mandar o primeiro ataque especial (2 segundos)
    
    // Configurações dos Ataques
    melee_range = 100; // Alcance do ataque de perto grande (aumentado)
    dash_length = 400; // Comprimento da investida (aumentado)
    dash_dir = 0;
    dash_duration = 35; // Duração do avanço do dash (aumentado)
    
    // Variáveis auxiliares de mira/consecução
    spike_x = 0;
    spike_y = 0;
    
    // Função principal de atualização do Boss
    static update = function(_inst) {
        var _player = obj_player;

        if (!instance_exists(_player)) {
            _inst.sprite_index = spr_idle;
            _inst.movement.vx = 0;
            _inst.movement.vy = 0;
            return;
        }

        // --- 1. LÓGICA DE DANOS E MORTE ---
        with (_inst) {
            var _ball = instance_place(x, y, obj_ball);
            if (_ball != noone && (abs(_ball.vx) > 0.5 || abs(_ball.vy) > 0.5)) {
                var _has_cooldown = variable_instance_exists(self, "hit_cooldown");
                var _can_damage = !_has_cooldown || (hit_cooldown <= 0);
                
                if (_can_damage) {
                    if (!variable_instance_exists(self, "hp")) {
                        hp = 7;
                    }
                    hp -= 1;
                    hit_cooldown = 20; // Frames de imunidade
                    
                    if (hp <= 0) {
                        instance_destroy();
                        return;
                    }
                }
            }
        }

        var _dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
        var _dir  = point_direction(_inst.x, _inst.y, _player.x, _player.y);

        // Reduz o cooldown de ataque na perseguição
        if (state == "chase" && attack_cooldown > 0) {
            attack_cooldown--;
        }

        // --- 2. MÁQUINA DE ESTADOS DO BOSS ---
        switch (state) {
            
            case "waiting":
                _inst.sprite_index = spr_idle;
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                
                if (_dist <= vision_range) {
                    state = "chase";
                    timer = 0;
                    attack_cooldown = 90; // Tempo curto antes de começar a atacar
                }
                break;

            case "chase":
                // 1. Persegue o jogador com velocidade moderada
                _inst.movement.vx = lengthdir_x(follow_speed, _dir);
                _inst.movement.vy = lengthdir_y(follow_speed, _dir);
                _inst.sprite_index = spr_idle;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;
                
                // 2. Escolha e Gatilho de Ataques Especiais
                if (attack_cooldown <= 0) {
                    // Se o player estiver PERTO: ataque melee (só ativa melee de perto)
                    if (_dist < melee_range) {
                        state = "prepare_melee";
                        timer = 0;
                        _inst.movement.vx = 0;
                        _inst.movement.vy = 0;
                    } else {
                        // Se o player estiver LONGE: escolhe entre dash, spike (e spawn na Fase 2)
                        var _attack_choice = "prepare_dash";
                        if (_inst.hp <= 3) {
                            _attack_choice = choose("prepare_dash", "prepare_spawn", "prepare_spike");
                        } else {
                            _attack_choice = choose("prepare_dash", "prepare_spike");
                        }
                        
                        state = _attack_choice;
                        timer = 0;
                        
                        // Zera velocidades ao entrar na preparação
                        _inst.movement.vx = 0;
                        _inst.movement.vy = 0;
                        
                        // Guarda dados importantes de mira nos ataques de trajeto
                        if (state == "prepare_dash") {
                            dash_dir = _dir;
                        } else if (state == "prepare_spike") {
                            spike_x = _player.x;
                            spike_y = _player.y;
                        }
                    }
                }
                break;

            #region ATAQUE 1: MELEE DE PERTO GRANDE
            case "prepare_melee":
                _inst.sprite_index = spr_attack;
                _inst.image_index = 0;
                _inst.image_speed = 0.05; // Segura no primeiro frame com animação quase parada
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;
                
                timer++;
                if (timer >= 45) { // 0.75 segundo de aviso
                    state = "melee";
                    timer = 0;
                    _inst.image_index = 1;
                    _inst.image_speed = 0.4; // Desfere o golpe rápido!
                }
                break;

            case "melee":
                _inst.sprite_index = spr_attack;
                
                // Aplica o dano no frame de impacto da animação
                if (timer == 0) {
                    if (instance_exists(_player)) {
                        var _impact_dist = point_distance(_inst.x, _inst.y, _player.x, _player.y);
                        if (_impact_dist <= melee_range) {
                            _player.hp.take_damage(_inst.x, _inst.y, _player.x, _player.y);
                        }
                    }
                    // Efeito de impacto melee grandioso
                    effect_create_above(ef_ring, _inst.x, _inst.y, 1, c_red);
                }
                
                timer++;
                if (timer >= 20) { // Finaliza a animação de ataque
                    state = "chase";
                    attack_cooldown = 120; // 2 segundos de cooldown
                    timer = 0;
                }
                break;
            #endregion

            #region ATAQUE 2: DASH GRANDE DE GROSSURA
            case "prepare_dash":
                _inst.sprite_index = spr_idle;
                _inst.image_xscale = (lengthdir_x(1, dash_dir) < 0) ? -1 : 1;
                
                // Trava a mira na direção do player
                dash_dir = point_direction(_inst.x, _inst.y, _player.x, _player.y);

                timer++;
                if (timer >= 50) { // 0.83 segundos de canalização com rastro grosso
                    state = "dashing";
                    timer = 0;
                    _inst.sprite_index = spr_attack;
                    _inst.image_speed = 0.5;
                }
                break;

            case "dashing":
                _inst.sprite_index = spr_attack;
                // Move o boss em altíssima velocidade
                _inst.movement.vx = lengthdir_x(dash_speed, dash_dir);
                _inst.movement.vy = lengthdir_y(dash_speed, dash_dir);
                
                // Rastro de poeira constante no pé do boss
                if (timer % 3 == 0) {
                    effect_create_above(ef_smoke, _inst.x, _inst.y, 0, c_gray);
                }

                // Verifica colisão com o player durante o avanço do dash
                with (_inst) {
                    var _p_hit = instance_place(x, y, obj_player);
                    if (_p_hit != noone) {
                        _p_hit.hp.take_damage(x, y, _p_hit.x, _p_hit.y);
                        other.state = "chase";
                        other.attack_cooldown = 150; // Aumenta o cooldown
                        other.timer = 0;
                    }
                }

                timer++;
                // Finaliza o dash por tempo ou se colidir com paredes (vx ou vy zerados)
                if (timer >= dash_duration || (_inst.movement.vx == 0 && _inst.movement.vy == 0)) {
                    state = "chase";
                    attack_cooldown = 120;
                    timer = 0;
                    _inst.sprite_index = spr_idle;
                }
                break;
            #endregion

            #region ATAQUE 3: SPAWN DE 10 CARANGUEJOS ALEATÓRIOS
            case "prepare_spawn":
                _inst.sprite_index = spr_idle;
                // Faz o boss tremer visualmente
                _inst.x += choose(-1, 1);
                _inst.y += choose(-1, 1);

                timer++;
                if (timer >= 60) { // 1 segundo carregando
                    state = "spawn";
                    timer = 0;
                }
                break;

            case "spawn":
                // Spawna 6 caranguejos aleatórios distribuídos ao redor do boss
                var _angle_step = 360 / 6;
                for (var i = 0; i < 6; i++) {
                    var _ang = i * _angle_step;
                    var _sx = _inst.x + lengthdir_x(48, _ang);
                    var _sy = _inst.y + lengthdir_y(48, _ang);
                    
                    // Verifica se a posição está livre de paredes de colisão cheia
                    var _tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));
                    if (tilemap_get_at_pixel(_tilemap, _sx, _sy) == 0) {
                        var _crab_type = choose(obj_enemy, obj_enemy_long, obj_enemy_red);
                        var _new_crab = instance_create_layer(_sx, _sy, "Instances", _crab_type);
                        
                        // Força o novo inimigo a "acordar" imediatamente no estado follow
                        if (instance_exists(_new_crab) && variable_instance_exists(_new_crab, "enemy_ai")) {
                            if (_crab_type == obj_enemy_long) {
                                _new_crab.enemy_ai.state = "active";
                            } else {
                                _new_crab.enemy_ai.state = "follow";
                            }
                            _new_crab.enemy_ai.timer = 0;
                        }
                        
                        // Efeito visual premium de invocação
                        effect_create_above(ef_smoke, _sx, _sy, 0, c_aqua);
                    }
                }
                
                // Grandioso efeito no centro do boss
                effect_create_above(ef_ring, _inst.x, _inst.y, 1, c_aqua);
                
                state = "chase";
                attack_cooldown = 240; // Spawns de caranguejos têm cooldown alto (4 segundos)
                timer = 0;
                break;
            #endregion

            #region ATAQUE 4: ESPINHO DO CHÃO NO PÉ DO PLAYER
            case "prepare_spike":
                _inst.sprite_index = spr_idle;
                
                // Segue o player levemente até os últimos frames do aviso
                if (timer < 45) {
                    spike_x = _player.x;
                    spike_y = _player.y;
                }

                timer++;
                if (timer >= 60) { // 1 segundo de aviso
                    state = "spike";
                    timer = 0;
                }
                break;

            case "spike":
                // Executa a explosão/espinho no local marcado
                effect_create_above(ef_ring, spike_x, spike_y, 0, c_red);
                effect_create_above(ef_smoke, spike_x, spike_y, 1, c_orange);
                
                if (instance_exists(_player)) {
                    var _spike_dist = point_distance(spike_x, spike_y, _player.x, _player.y);
                    if (_spike_dist <= 55) { // Área de impacto aumentada para 55px
                        _player.hp.take_damage(spike_x, spike_y, _player.x, _player.y);
                    }
                }
                
                state = "chase";
                attack_cooldown = 120;
                timer = 0;
                break;
            #endregion
        }
    };

    // Função de desenho de avisos visuais do Boss
    static draw = function(_inst) {
        var _player = obj_player;
        if (!instance_exists(_player)) return;

        // --- DESENHO DE AVISOS DEPENDENDO DO ESTADO ---
        switch (state) {
            
            case "prepare_melee":
                // 1. Círculo vermelho semi-transparente piscando
                draw_set_alpha(0.2 + sin(current_time / 80.0) * 0.1);
                draw_circle_color(_inst.x, _inst.y, melee_range, c_red, c_red, false);
                
                // 2. Contorno do círculo de alcance
                draw_set_alpha(0.6);
                draw_circle_color(_inst.x, _inst.y, melee_range, c_red, c_red, true);
                draw_set_alpha(1.0);
                break;

            case "prepare_dash":
                // Linha de mira da investida super grossa e piscando
                var _tx = _inst.x + lengthdir_x(dash_length, dash_dir);
                var _ty = _inst.y + lengthdir_y(dash_length, dash_dir);
                
                draw_set_alpha(0.25 + sin(current_time / 60.0) * 0.15);
                draw_line_width_color(_inst.x, _inst.y, _tx, _ty, 48, c_red, c_red); // Rastro com grossura de 48px
                
                draw_set_alpha(0.7);
                draw_line_width_color(_inst.x, _inst.y, _tx, _ty, 2, c_white, c_white); // Fio central branco
                draw_set_alpha(1.0);
                break;

            case "prepare_spawn":
                // Aura ciano indicando invocação em massa de caranguejos
                draw_set_alpha(0.2 + sin(current_time / 50.0) * 0.12);
                draw_circle_color(_inst.x, _inst.y, 80, c_aqua, c_aqua, false);
                
                draw_set_alpha(0.65);
                draw_circle_color(_inst.x, _inst.y, 80, c_aqua, c_aqua, true);
                draw_set_alpha(1.0);
                break;

            case "prepare_spike":
                // Círculo vermelho sob o pé do player (área aumentada)
                draw_set_alpha(0.25);
                draw_circle_color(spike_x, spike_y, 55, c_red, c_red, false);
                
                // Contorno vermelho
                draw_set_alpha(0.6);
                draw_circle_color(spike_x, spike_y, 55, c_red, c_red, true);
                
                // Anel branco fechando em direção ao centro indicando tempo
                var _progress = timer / 60.0;
                var _r = 55.0 * (1.0 - clamp(_progress, 0.0, 1.0));
                draw_set_alpha(0.85);
                draw_circle_color(spike_x, spike_y, _r, c_white, c_white, true);
                draw_set_alpha(1.0);
                break;
        }
    };
}
