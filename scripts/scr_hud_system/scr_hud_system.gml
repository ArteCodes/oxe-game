/// @function   HudSystem(target, heart_1, heart_2, heart_3)
/// @description Gerencia e desenha todos os elementos do HUD na tela.
/// @param {Id.Instance}    target   Instancia do obj_player
/// @param {Asset.GMSprite} heart_1  Sprite coracao cheio (3 vidas)
/// @param {Asset.GMSprite} heart_2  Sprite coracao meio (2 vidas)
/// @param {Asset.GMSprite} heart_3  Sprite coracao pouquinho (1 vida)
function HudSystem(_target, _heart_1, _heart_2, _heart_3) constructor {

    target  = _target;
    heart_1 = _heart_1; // 3 vidas
    heart_2 = _heart_2; // 2 vidas
    heart_3 = _heart_3; // 1 vida

    /// @function   draw()
    /// @description Chame no evento Draw GUI do obj_player.
    static draw = function() {
        if (!instance_exists(target)) return;
        _draw_hearts();
    };

    /// @function   _draw_hearts()
    /// @description Escolhe o sprite certo baseado nos coracoes atuais.
    static _draw_hearts = function() {
        var _hearts = target.hp.hearts;

        // 0 vidas — nao desenha nada
        if (_hearts <= 0) return;

		// Posicao: canto inferior esquerdo com espacamento
		var _ww = display_get_gui_width();
		var _wh = display_get_gui_height();
		var _cx = _ww * 0.05;        // 5% da largura — espacamento da esquerda
		var _cy = _wh * 0.88;        // 88% da altura — perto do fundo

        // Escolhe o sprite baseado na vida atual
        var _spr;
        switch (_hearts) {
            case 3: _spr = heart_1; break; // cheio
            case 2: _spr = heart_2; break; // meio
            case 1: _spr = heart_3; break; // pouquinho
        }

        draw_sprite_ext(_spr, 0, _cx, _cy, 2, 2, 0, c_white, 1);
    };

}