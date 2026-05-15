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
        switch (state) {
            case "follow":
                // Segue o jogador usando vetores
                var _dir = point_direction(_inst.x, _inst.y, _player.x, _player.y);
                
                // MUDANÇA AQUI: Injeta a velocidade no módulo de movimento em vez de alterar o X e Y diretamente!
                _inst.movement.vx = lengthdir_x(follow_speed, _dir);
                _inst.movement.vy = lengthdir_y(follow_speed, _dir);
                
                // Animação e Direção Visual
                _inst.sprite_index = spr_walk;
                _inst.image_xscale = (_player.x < _inst.x) ? -1 : 1;

                // Timer para iniciar a investida
                timer++;
                if (timer >= 120) { // Inicia após 2 segundos (a 60fps)
                    state = "charging";
                    timer = 0;
                    dash_dir = _dir; // Trava a direção da investida
                }
                break;

            case "charging":
                _inst.sprite_index = spr_idle;
                
                // MUDANÇA AQUI: Garante que o caranguejo zere a velocidade e pare de andar enquanto carrega o dash
                _inst.movement.vx = 0;
                _inst.movement.vy = 0;
                
                timer++;
                if (timer >= 60) { // Carrega por 1 segundo
                    state = "dashing";
                    timer = 0;
                }
                break;

            case "dashing":
                // MUDANÇA AQUI: Injeta a super velocidade na direção travada
                _inst.movement.vx = lengthdir_x(dash_speed, dash_dir);
                _inst.movement.vy = lengthdir_y(dash_speed, dash_dir);
                
                timer++;
                if (timer >= 25) { // Duração do dash
                    state = "follow";
                    timer = 0;
                }
                break;
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