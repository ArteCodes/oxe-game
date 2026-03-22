// --- Personagem ---
draw_self();

// --- Mira ---
// Trajetoria simulada da bolinha, so aparece ao carregar
if (slingshot.is_charging) {
    var _data = slingshot.get_shot_data();
    aim.draw(x, y, mouse_x, mouse_y, _data.speed, _data.distance);
}

// --- Barra de carregamento ---
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
    if (_ratio >= 1.0) _shake = irandom_range(-1, 1);

    // Cor progressiva: branco -> verde -> amarelo -> vermelho -> escurece
    var _r, _g, _b;
    if (_timeout_ratio <= 0.5) {
        var _t = _timeout_ratio / 0.5;
        _r = lerp(255, 0, _t);
        _g = 255;
        _b = lerp(255, 0, _t);
    } else if (_timeout_ratio <= 0.75) {
        var _t = (_timeout_ratio - 0.5) / 0.25;
        _r = lerp(0, 255, _t);
        _g = 255;
        _b = 0;
    } else if (_timeout_ratio <= 0.95) {
        var _t = (_timeout_ratio - 0.75) / 0.20;
        _r = 255;
        _g = lerp(255, 0, _t);
        _b = 0;
    } else {
        var _t = (_timeout_ratio - 0.95) / 0.05;
        _r = lerp(255, 80, _t);
        _g = 0;
        _b = 0;
    }

    // Fundo da barra
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

// --- Debug: estado do dodge (remover depois) ---
draw_set_color(c_white);
var _estado = "LIVRE";
if (dodge.is_dodging)  _estado = "DODGE";
if (dodge.on_cooldown) _estado = "COOLDOWN";
draw_text(x - 20, y - 40, _estado);