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
            with (_inst) {
                _ball_hit = instance_place(x, y, obj_ball);
            }

            if (_ball_hit != noone) {
                is_active = true;
                _inst.sprite_index = spr_on;
                timer = 120; // Define 2 segundos (60 frames * 2)
            } else {
                _inst.sprite_index = spr_off;
            }
        } 
        // LÓGICA DE DESATIVAÇÃO (Contagem regressiva)
        else {
            timer --; // Reduz o tempo a cada quadro
            
            if (timer <= 0) {
                is_active = false;
                _inst.sprite_index = spr_off;
                // Opcional: Se quiser que a bola seja destruída ao tocar, 
                // a lógica deve estar no obj_ball ou aqui usando with.
            }
        }
    }
}