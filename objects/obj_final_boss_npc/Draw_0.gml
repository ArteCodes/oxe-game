
// 2. Desenha o Rei Caranguejo (estátua, em transição ou ativo)
// Alinha a base dos sprites de 80px (glow e active) com a base do sprite de 64px (statue)
var _draw_y = y;
if (sprite_index == spr_final_boss_glow || sprite_index == spr_final_boss_active) {
    _draw_y = y - 8;
}

draw_sprite_ext(sprite_index, image_index, x, _draw_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
