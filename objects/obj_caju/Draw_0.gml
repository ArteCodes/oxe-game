// --- Evento Desenhar (Draw) do obj_caju ---

// 1. Desenha a sombra sob o caju (escala diminui conforme a altura z aumenta)
var _shadow_scale = clamp(1.0 - (abs(z_height) / 60.0), 0.2, 1.0) * scale_pulse;
draw_set_color(c_black);
draw_set_alpha(0.35 * _shadow_scale);
draw_ellipse(x - 6 * _shadow_scale, y - 3 * _shadow_scale, x + 6 * _shadow_scale, y + 3 * _shadow_scale, false);
draw_set_alpha(1.0);

// 2. Desenha o caju com o deslocamento z vertical simulando salto e flutuação
var _draw_y = y + z_height;
draw_sprite_ext(sprite_index, image_index, x, _draw_y, image_xscale * scale_pulse, image_yscale * scale_pulse, image_angle, image_blend, image_alpha);
