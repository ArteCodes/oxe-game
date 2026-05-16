// Desenha o fundo capturado (o jogo "congelado" visualmente)
if (sprite_exists(screen_sprite)) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    draw_sprite_stretched(screen_sprite, 0, 0, 0, _gui_w, _gui_h);
}

// Desenha o menu por cima
pause_sys.draw();