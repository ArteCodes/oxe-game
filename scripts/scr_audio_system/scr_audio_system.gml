// --- Inicialização Global de Volume e Mudo ---
// Garante que essas variáveis existam mesmo se o jogo for iniciado diretamente de salas de teste/gameplay
if (!variable_global_exists("master_volume")) {
    global.master_volume = 1.0;
}
if (!variable_global_exists("master_mute")) {
    global.master_mute = false;
}
audio_set_master_gain(0, global.master_mute ? 0 : global.master_volume);

/// @function play_bgm(music_asset)
/// @description Plays the specified music track in loop while stopping any other active bgm tracks.
/// @param {asset.sound} _music_asset The sound resource to play
function play_bgm(_music_asset) {
    var _bgms = [
        snd_sinistral_battle,
        snd_boss,
        snd_victory,
        snd_main_menu,
        snd_death,
        snd_tutorial
    ];

    // Stop all other background music tracks
    for (var _i = 0; _i < array_length(_bgms); _i++) {
        var _m = _bgms[_i];
        if (_m != _music_asset) {
            audio_stop_sound(_m);
        }
    }

    // Play the target track in loop if it's not already playing
    if (!audio_is_playing(_music_asset)) {
        audio_play_sound(_music_asset, 1000, true);
    }
}
