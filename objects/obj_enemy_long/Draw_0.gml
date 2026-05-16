// Desenha o inimigo
draw_self();

// Desenha a mira se estiver prestes a atirar
if (draw_aim) {
    draw_set_alpha(0.2);
    draw_set_color(c_aqua);
    // Mira estilo "Normal Crab" (Faixa larga semi-transparente)
    draw_line_width(x, y - 8, aim_x, aim_y, 15);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
