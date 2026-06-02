// Sincroniza dinamicamente o tamanho do GUI com a janela do jogo caso o usuário a redimensione no menu
if (window_get_width() > 0 && window_get_height() > 0) {
    if (display_get_gui_width() != window_get_width() || display_get_gui_height() != window_get_height()) {
        var _ww = window_get_width();
        var _wh = window_get_height();
        display_set_gui_size(_ww, _wh);
        surface_resize(application_surface, _ww, _wh);
        global.player_window_width = _ww;
        global.player_window_height = _wh;
    }
}
menu.update(self);