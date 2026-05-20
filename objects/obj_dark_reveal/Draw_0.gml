// --- Evento Desenhar (Draw) do obj_dark_reveal ---
// Desenha um retângulo escuro cobrindo a zona.
// A opacidade é controlada pelo dark_alpha (0 = invisível, 1 = preto total).

if (dark_alpha > 0.01) {
    draw_set_alpha(dark_alpha);
    draw_rectangle_color(
        x, y,
        x + zone_w, y + zone_h,
        c_black, c_black, c_black, c_black,
        false
    );
    draw_set_alpha(1.0);
}
