if (sprite_exists(screen_sprite)) {
    sprite_delete(screen_sprite);
}
instance_activate_all();

// Resume all paused BGM tracks
var _bgms = [
    snd_sinistral_battle,
    snd_boss,
    snd_victory,
    snd_main_menu,
    snd_death,
    snd_tutorial
];
for (var _i = 0; _i < array_length(_bgms); _i++) {
    if (audio_is_paused(_bgms[_i])) {
        audio_resume_sound(_bgms[_i]);
    }
}