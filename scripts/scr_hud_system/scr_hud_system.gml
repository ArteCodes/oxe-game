/// @function   HudSystem(heart_1, heart_2, heart_3)
/// @description Gerencia e desenha todos os elementos do HUD na tela.
///              Nao acessa outros sistemas diretamente — recebe os dados via parametro.
///              Chame draw() no evento Draw GUI do obj_player passando os valores atuais.
/// @param {Asset.GMSprite} heart_1  Sprite coracao cheio (exibido com 3 vidas)
/// @param {Asset.GMSprite} heart_2  Sprite coracao meio (exibido com 2 vidas)
/// @param {Asset.GMSprite} heart_3  Sprite coracao pouquinho (exibido com 1 vida)
function HudSystem(_heart_1, _heart_2, _heart_3) constructor {

    heart_1 = _heart_1; // 3 vidas
    heart_2 = _heart_2; // 2 vidas
    heart_3 = _heart_3; // 1 vida

    /// @function   draw(hearts, charge_ratio, reload_ratio, stone_count)
    /// @description Desenha todos os elementos do HUD. Chame no evento Draw GUI.
    ///              Nenhum dado e lido diretamente de outros sistemas — tudo via parametro.
    /// @param {real} hearts        Coracoes atuais do jogador (0 a 3)
    /// @param {real} charge_ratio  Progresso do carregamento do estilingue (0.0 a 1.0)
    /// @param {real} reload_ratio  Progresso da recarga da bolsa — tecla R (0.0 a 1.0)
    /// @param {real} stone_count   Quantidade de pedras no estoque (0 a 3)
    static draw = function(_hearts, _charge_ratio, _reload_ratio, _stone_count) {
        _draw_hearts(_hearts);
        _draw_charge_bar(_charge_ratio);
        _draw_reload_bar(_reload_ratio);
        _draw_stone_count(_stone_count);
    };

    /// @function   _draw_hearts(hearts)
    /// @description Escolhe e desenha o sprite correto baseado nos coracoes atuais.
    /// @param {real} hearts  Coracoes atuais (0 a 3)
    static _draw_hearts = function(_hearts) {
        if (_hearts <= 0) return;

        var _ww  = display_get_gui_width();
        var _wh  = display_get_gui_height();
        var _cx  = _ww * 0.05; // 5% da largura — espacamento da esquerda
        var _cy  = _wh * 0.88; // 88% da altura — perto do fundo

        var _spr;
        switch (_hearts) {
            case 3: _spr = heart_1; break;
            case 2: _spr = heart_2; break;
            case 1: _spr = heart_3; break;
        }

        draw_sprite_ext(_spr, 0, _cx, _cy, 2, 2, 0, c_white, 1);
    };

    /// @function   _draw_charge_bar(ratio)
    /// @description Desenha a barra de carregamento do estilingue.
    ///              So aparece quando ratio > 0 (estilingue sendo carregado).
    /// @param {real} ratio  Progresso do carregamento (0.0 a 1.0)
    static _draw_charge_bar = function(_ratio) {
        if (_ratio <= 0) return;

        var _ww     = display_get_gui_width();
        var _wh     = display_get_gui_height();
        var _bx     = _ww * 0.05;
        var _by     = _wh * 0.83;
        var _bw     = 80;
        var _bh     = 6;

        // Fundo da barra
        draw_set_color(c_dkgray);
        draw_set_alpha(0.6);
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

        // Preenchimento
        var _fill_color = (_ratio >= 1) ? c_yellow : c_white;
        draw_set_color(_fill_color);
        draw_set_alpha(1);
        draw_rectangle(_bx, _by, _bx + (_bw * _ratio), _by + _bh, false);

        draw_set_alpha(1);
    };

    /// @function   _draw_reload_bar(ratio)
    /// @description Desenha a barra de recarga da bolsa (tecla R segurada).
    ///              So aparece quando ratio > 0 (recarga em andamento).
    /// @param {real} ratio  Progresso da recarga (0.0 a 1.0)
    static _draw_reload_bar = function(_ratio) {
        if (_ratio <= 0) return;

        var _ww = display_get_gui_width();
        var _wh = display_get_gui_height();
        var _bx = _ww * 0.05;
        var _by = _wh * 0.91;
        var _bw = 80;
        var _bh = 6;

        draw_set_color(c_dkgray);
        draw_set_alpha(0.6);
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

        draw_set_color(c_aqua);
        draw_set_alpha(1);
        draw_rectangle(_bx, _by, _bx + (_bw * _ratio), _by + _bh, false);

        draw_set_alpha(1);
    };

    /// @function   _draw_stone_count(count)
    /// @description Desenha o contador de pedras no estoque.
    ///              Nao desenha nada se o estoque estiver vazio.
    /// @param {real} count  Pedras no estoque (0 a 3)
    static _draw_stone_count = function(_count) {
        if (_count <= 0) return;

        var _ww = display_get_gui_width();
        var _wh = display_get_gui_height();
        var _tx = _ww * 0.12;
        var _ty = _wh * 0.88;

        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_set_font(-1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(_tx, _ty, "x" + string(_count));
    };
}
