window_set_fullscreen(false);
if (variable_global_exists("player_window_width") && variable_global_exists("player_window_height")) {
    window_set_size(global.player_window_width, global.player_window_height);
} else {
    window_set_size(1280, 720);
    global.player_window_width = 1280;
    global.player_window_height = 720;
}
if (!variable_global_exists("master_volume")) {
    global.master_volume = 1.0;
}
if (!variable_global_exists("master_mute")) {
    global.master_mute = false;
}
audio_set_master_gain(0, global.master_mute ? 0 : global.master_volume);

menu = new MenuSystem(fnt_menu, spr_menu_background);

// --- Inicia a música do Menu Principal em loop ---
play_bgm(snd_main_menu);