// --- Evento Desenhar (Draw) ---

// 1. Desenha o rastro (Trail)
for (var i = 0; i < ds_list_size(trail_list); i++) {
    var _point = trail_list[| i];
    var _alpha = 0.5 * (1 - (i / trail_max));
    var _scale = 1 - (i / trail_max);
    
    draw_set_alpha(_alpha);
    draw_set_color(c_aqua);
    // Desenha círculos como rastro (bolhas)
    draw_circle(_point.tx, _point.ty, 4 * _scale, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

// 2. Desenha a bolha principal (Usando spr_ball como placeholder)
if (sprite_exists(spr_ball)) {
    draw_sprite_ext(spr_ball, 0, x, y, 0.6, 0.6, 0, c_aqua, 1);
} else {
    draw_circle_color(x, y, 6, c_aqua, c_blue, false);
}
