// --- Evento Desenhar (Draw) do obj_door_next ---
// Portal mágico desenhado 100% via código — sem sprites externos

if (!visible) exit;

// --- Cores do Portal ---
var _color_outer = make_color_rgb(80, 50, 200);    // Anel externo: roxo profundo
var _color_inner = make_color_rgb(120, 180, 255);   // Núcleo: azul celestial
var _color_glow  = make_color_rgb(180, 100, 255);   // Brilho: lilás vibrante
var _color_core  = make_color_rgb(220, 200, 255);   // Centro: branco-lilás

var _sc = portal_scale;
var _al = portal_alpha;

// --- 1. Brilho de Fundo (Glow suave no chão) ---
draw_set_alpha(_al * 0.15);
draw_set_color(_color_glow);
draw_circle(x, y, 40 * _sc, false);
draw_set_alpha(_al * 0.08);
draw_circle(x, y, 55 * _sc, false);

// --- 2. Anel Externo Rotativo (Segmentos) ---
var _segments = 12;
var _outer_r = 28 * _sc;
for (var _i = 0; _i < _segments; _i++) {
    var _a1 = portal_angle + (_i * (360 / _segments));
    var _a2 = _a1 + (360 / _segments) * 0.6; // Segmentos com gaps
    
    var _x1 = x + lengthdir_x(_outer_r, _a1);
    var _y1 = y + lengthdir_y(_outer_r, _a1);
    var _x2 = x + lengthdir_x(_outer_r, _a2);
    var _y2 = y + lengthdir_y(_outer_r, _a2);
    
    draw_set_alpha(_al * (0.6 + sin(portal_pulse + _i) * 0.2));
    draw_set_color(_color_outer);
    draw_line_width(_x1, _y1, _x2, _y2, 2.5 * _sc);
}

// --- 3. Anel Interno Contra-Rotativo ---
var _inner_r = 18 * _sc;
var _inner_segments = 8;
for (var _i = 0; _i < _inner_segments; _i++) {
    var _a1 = -portal_angle * 1.5 + (_i * (360 / _inner_segments));
    var _a2 = _a1 + (360 / _inner_segments) * 0.5;
    
    var _x1 = x + lengthdir_x(_inner_r, _a1);
    var _y1 = y + lengthdir_y(_inner_r, _a1);
    var _x2 = x + lengthdir_x(_inner_r, _a2);
    var _y2 = y + lengthdir_y(_inner_r, _a2);
    
    draw_set_alpha(_al * (0.7 + sin(portal_pulse * 2 + _i) * 0.15));
    draw_set_color(_color_inner);
    draw_line_width(_x1, _y1, _x2, _y2, 2 * _sc);
}

// --- 4. Núcleo Pulsante (Centro do portal) ---
var _core_r = (10 + sin(portal_pulse * 3) * 2) * _sc;
draw_set_alpha(_al * 0.4);
draw_set_color(_color_inner);
draw_circle(x, y, _core_r + 4, false);

draw_set_alpha(_al * 0.7);
draw_set_color(_color_glow);
draw_circle(x, y, _core_r, false);

draw_set_alpha(_al * 0.9);
draw_set_color(_color_core);
draw_circle(x, y, _core_r * 0.5, false);

// --- 5. Raios de Energia (4 raios rotativos saindo do centro) ---
var _ray_count = 4;
for (var _i = 0; _i < _ray_count; _i++) {
    var _ra = portal_angle * 0.8 + (_i * (360 / _ray_count));
    var _ray_len = (22 + sin(portal_pulse * 2 + _i * 1.5) * 6) * _sc;
    
    var _rx = x + lengthdir_x(_ray_len, _ra);
    var _ry = y + lengthdir_y(_ray_len, _ra);
    
    draw_set_alpha(_al * (0.3 + sin(portal_pulse + _i) * 0.15));
    draw_set_color(_color_glow);
    draw_line_width(x, y, _rx, _ry, 1.5 * _sc);
}

// --- 6. Partículas Flutuantes de Energia ---
for (var _i = 0; _i < array_length(portal_particles); _i++) {
    var _p = portal_particles[_i];
    draw_set_alpha(_p.palpha * _al);
    draw_set_color(_color_inner);
    draw_circle(_p.px, _p.py, 1.5 * _p.pscale, false);
}

// --- 7. Borda Circular Contínua (Contorno suave do portal) ---
draw_set_alpha(_al * 0.35);
draw_set_color(_color_outer);
draw_circle(x, y, _outer_r + 2, true);
draw_set_alpha(_al * 0.2);
draw_set_color(_color_glow);
draw_circle(x, y, _outer_r + 6, true);

// --- Reset ---
draw_set_alpha(1.0);
draw_set_color(c_white);
