// Rastro — conecta as últimas posições como uma linha branca com fade
if (ds_list_size(trail) > 1) {
    for (var _i = 1; _i < ds_list_size(trail); _i++) {
        var _p1 = trail[| _i - 1];
        var _p2 = trail[| _i];
        draw_set_alpha(_i / trail_max);
        draw_set_color(c_white);
        draw_line_width(_p1.tx, _p1.ty, _p2.tx, _p2.ty, 3);
    }
}
draw_set_alpha(1);

// Bolinha
draw_set_color(c_white);
draw_circle(x, y, 6, false);