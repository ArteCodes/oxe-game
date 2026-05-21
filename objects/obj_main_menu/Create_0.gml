window_set_fullscreen(false);
if (variable_global_exists("player_window_width") && variable_global_exists("player_window_height")) {
    window_set_size(global.player_window_width, global.player_window_height);
} else {
    window_set_size(1280, 720);
    global.player_window_width = 1280;
    global.player_window_height = 720;
}
menu = new MenuSystem(fnt_menu, spr_menu_background);