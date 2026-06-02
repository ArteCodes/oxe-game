/// @description Sistema modular para botões com temporizador
/// @param {asset} _spr_off Sprite do botão desligado
/// @param {asset} _spr_on Sprite do botão ligado
function ButtonLogic(_spr_off, _spr_on) constructor {
    spr_off = _spr_off;
    spr_on = _spr_on;
    is_active = false;
    timer = 0; // Nova variável para controlar o tempo

    static update = function(_inst) {
        // LÓGICA DE ATIVAÇÃO
        if (!is_active) {
            var _ball_hit = noone;
            var _player_hit = noone;
            with (_inst) {
                _ball_hit = instance_place(x, y, obj_ball);
                // Proximidade generosa com a bolinha (28px) como fallback
                if (_ball_hit == noone) {
                    var _nearest_ball = instance_nearest(x, y, obj_ball);
                    if (_nearest_ball != noone && point_distance(x, y, _nearest_ball.x, _nearest_ball.y) < 28) {
                        _ball_hit = _nearest_ball;
                    }
                }
                
                _player_hit = instance_place(x, y, obj_player);
                // Proximidade generosa com o player (28px) como fallback
                if (_player_hit == noone) {
                    var _nearest_player = instance_nearest(x, y, obj_player);
                    if (_nearest_player != noone && point_distance(x, y, _nearest_player.x, _nearest_player.y) < 28) {
                        _player_hit = _nearest_player;
                    }
                }
            }

            if (_ball_hit != noone || _player_hit != noone) {
                is_active = true;
                timer = 180; // Define 3 segundos (60 frames * 3) para dar mais tempo ao jogador
                audio_play_sound(snd_button, 10, false);
                if (_ball_hit != noone) {
                    audio_play_sound(snd_stone_impact, 10, false);
                }
            }
        } 
        // LÓGICA DE DESATIVAÇÃO (Contagem regressiva)
        else {
            // Mantém ativo enquanto o jogador estiver em cima, renovando o temporizador
            var _player_on = noone;
            with (_inst) {
                _player_on = instance_place(x, y, obj_player);
                if (_player_on == noone) {
                    var _nearest_player = instance_nearest(x, y, obj_player);
                    if (_nearest_player != noone && point_distance(x, y, _nearest_player.x, _nearest_player.y) < 28) {
                        _player_on = _nearest_player;
                    }
                }
            }
            if (_player_on != noone) {
                timer = 180;
            }
            
            timer--; // Reduz o tempo a cada quadro
            
            if (timer <= 0) {
                is_active = false;
            }
        }
    }
}