// --- Evento Destruir (Destroy) do obj_boss ---

// 1. Reproduz o áudio dramático de morte do chefe
audio_play_sound(snd_boss_death, 10, false);

// 2. Cria a carcaça de morte permanente do chefe no chão
var _dead = safe_create_layer(x, y, "Instances", obj_boss_dead);
if (instance_exists(_dead)) {
    _dead.image_xscale = image_xscale;
    _dead.image_yscale = image_yscale;
}

// 3. Derruba 3 cajus de cura para recompensar o jogador
for (var i = 0; i < 3; i++) {
    var _cx = x + random_range(-32, 32);
    var _cy = y + random_range(-32, 32);
    safe_create_layer(_cx, _cy, "Instances", obj_caju);
}
