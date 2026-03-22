// Desenha o personagem
draw_self();

// --- Barra de carregamento do estilingue ---
if (slingshot.is_charging) {
    var _ratio         = slingshot.get_charge_ratio();
    var _timeout_ratio = slingshot.charge_time / slingshot.CHARGE_TIMEOUT;
    var _bx     = x + 14;
    var _by     = y + 8;
    var _height = 24;
    var _width  = 4;
    var _filled = _height * min(_ratio, 1.0);

    // Tremido quando completamente carregado
    var _shake = 0;
    if (_ratio >= 1.0) {
        _shake = irandom_range(-1, 1);
    }

    // Cor progressiva:
    // 0% -> 50%  : branco -> amarelo
    // 50% -> 100%: amarelo (carregado)
    // 100%+      : amarelo -> vermelho -> preto (perigo de estouro)
    var _r, _g, _b;
    if (_timeout_ratio <= 0.5) {
        // branco para amarelo
        var _t = _timeout_ratio / 0.5;
        _r = 255;
        _g = 255;
        _b = lerp(255, 0, _t);
    } else if (_timeout_ratio <= 0.5) {
        // amarelo puro (zona segura carregada)
        _r = 255; _g = 255; _b = 0;
    } else {
        // amarelo -> vermelho -> preto (zona de perigo)
        var _t = (_timeout_ratio - 0.5) / 0.5;
        _r = lerp(255, 0, _t * _t);
        _g = lerp(255, 0, _t);
        _b = 0;
    }

    // Fundo
    draw_set_color(c_dkgray);
    draw_rectangle(_bx + _shake, _by - _height, _bx + _width + _shake, _by, false);

    // Preenchimento com cor calculada
    draw_set_colour(make_colour_rgb(_r, _g, _b));
    draw_rectangle(_bx + _shake, _by - _filled, _bx + _width + _shake, _by, false);

    // Contorno
    draw_set_color(c_black);
    draw_rectangle(_bx + _shake, _by - _height, _bx + _width + _shake, _by, true);

    draw_set_alpha(1);
}

// --- Estado do dodge (debug — remover depois) ---
draw_set_color(c_white);
var _estado = "LIVRE";
if (dodge.is_dodging)  _estado = "DODGE";
if (dodge.on_cooldown) _estado = "COOLDOWN";
draw_text(x - 20, y - 40, _estado);

// --- Mira ---
if (slingshot.is_charging) {
    var _data = slingshot.get_shot_data();
    aim.draw(x, y, mouse_x, mouse_y, _data.speed, _data.distance);
}