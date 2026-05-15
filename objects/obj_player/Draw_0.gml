// --- Personagem ---
draw_self();

// --- Mira (lancada do centro visual do personagem) ---
if (slingshot.is_charging) {
    var _data = slingshot.get_shot_data();
    aim.draw(x, y, mouse_x, mouse_y, _data.speed, _data.distance);
}


// --- Barra de carregamento do tiro (lado direito) ---
if (slingshot.is_charging) {
    var _ratio         = slingshot.get_charge_ratio();
    var _timeout_ratio = slingshot.charge_time / slingshot.CHARGE_TIMEOUT;
    var _bx     = x + 20;  // 20px a direita do origin
    var _by     = y + 12;  // base alinhada com o pe do sprite
    var _height = 24;
    var _width  = 4;
    var _filled = _height * min(_ratio, 1.0);

    var _shake = 0;
    if (_ratio >= 1.0) _shake = irandom_range(-1, 1);

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

    draw_set_color(c_dkgray);
    draw_rectangle(_bx + _shake, _by - _height, _bx + _width + _shake, _by, false);
    draw_set_colour(make_colour_rgb(_r, _g, _b));
    draw_rectangle(_bx + _shake, _by - _filled, _bx + _width + _shake, _by, false);
    draw_set_color(c_black);
    draw_rectangle(_bx + _shake, _by - _height, _bx + _width + _shake, _by, true);
    draw_set_alpha(1);
}

// --- Circulo de recarga da bolsa (acima da cabeca) ---
if (ball.is_reloading) {
    var _ratio  = ball.get_reload_ratio();
    var _cx     = x;
    var _cy     = y - 36;
    var _radius = 10;
    var _steps  = 32;

    draw_set_alpha(0.3);
    draw_set_color(c_dkgray);
    draw_circle(_cx, _cy, _radius, false);

    draw_set_alpha(1);
    draw_set_color(c_white);

    var _total_angle = 360 * _ratio;
    var _start       = -90;

    for (var _i = 0; _i < _steps; _i++) {
        var _a1 = _start + (_total_angle / _steps) * _i;
        var _a2 = _start + (_total_angle / _steps) * (_i + 1);
        if (_a2 - _start > _total_angle) break;

        var _x1 = _cx + lengthdir_x(_radius, _a1);
        var _y1 = _cy + lengthdir_y(_radius, _a1);
        var _x2 = _cx + lengthdir_x(_radius, _a2);
        var _y2 = _cy + lengthdir_y(_radius, _a2);
        draw_line_width(_x1, _y1, _x2, _y2, 4);
    }

    draw_set_alpha(1);
}
// --- Debug: estado do dodge (remover depois) ---
// draw_set_color(c_white);
// var _estado = "LIVRE";
// if (dodge.is_dodging)  _estado = "DODGE";
// if (dodge.on_cooldown) _estado = "COOLDOWN";
// draw_text(x - 20, y - 40, _estado);

// --- 5. Sistema de Diálogo ---
if (dialogo != undefined && dialogo.ativo == true) {
    
    // Verifica se o NPC que estamos conversando existe na sala
    if (instance_exists(npc_foco)) {
        
        // Desenha a caixa usando o X e o Y do NPC, e não do jogador!
        dialogo.desenhar(npc_foco.x, npc_foco.y - 60); 
    }
}