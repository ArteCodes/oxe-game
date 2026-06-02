death_sys = new DeathMenuSystem(fnt_menu);
instance_deactivate_all(true);

// --- Interrompe todos os sons e toca a música de morte em loop ---
audio_stop_all();
audio_play_sound(snd_death, 1000, true);
