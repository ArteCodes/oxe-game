pause_sys = new PauseMenuSystem(-1); // Usando -1 para fonte padrão se fnt_menu não existir
screen_sprite = -1;

// Captura a tela atual para mostrar no fundo do pause com segurança
if (surface_exists(application_surface)) {
    var _w = surface_get_width(application_surface);
    var _h = surface_get_height(application_surface);
    
    // Só tenta criar o sprite se as dimensões forem válidas (evita erro de GPU ao minimizar)
    if (_w > 0 && _h > 0) {
        try {
            screen_sprite = sprite_create_from_surface(application_surface, 0, 0, _w, _h, false, false, 0, 0);
        } catch (_ex) {
            screen_sprite = -1;
            show_debug_message("Erro ao capturar superfície: " + string(_ex));
        }
    }
}

// Pause all active BGM tracks
var _bgms = [
    snd_sinistral_battle,
    snd_boss,
    snd_victory,
    snd_main_menu,
    snd_death,
    snd_tutorial
];
for (var _i = 0; _i < array_length(_bgms); _i++) {
    if (audio_is_playing(_bgms[_i])) {
        audio_pause_sound(_bgms[_i]);
    }
}

// Stop looping SFX
if (audio_is_playing(snd_player_run)) {
    audio_stop_sound(snd_player_run);
}
if (audio_is_playing(snd_pull)) {
    audio_stop_sound(snd_pull);
}

instance_deactivate_all(true);