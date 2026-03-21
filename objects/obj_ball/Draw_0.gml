// Rastro neon
for (var _i = 0; _i < ds_list_size(trail); _i++) {
    var _p     = trail[| _i];
    var _alpha = (_i / trail_max);
    draw_set_alpha(_alpha);
    draw_set_color(c_yellow);
    draw_circle(_p.tx, _p.ty, 3, false);
}
draw_set_alpha(1);

// Bolinha
draw_set_color(c_yellow);
draw_circle(x, y, 6, false);