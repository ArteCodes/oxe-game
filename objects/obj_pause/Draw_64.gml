// Desenha o fundo capturado (o jogo "congelado" visualmente)
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

if (sprite_exists(screen_sprite)) {
    draw_sprite_stretched(screen_sprite, 0, 0, 0, _gui_w, _gui_h);
} else {
    // Fallback caso a captura de tela falhe: desenha um fundo preto semitransparente
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Desenha o menu por cima
pause_sys.draw();