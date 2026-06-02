// --- Evento Destruir (Destroy) do obj_enemy ---
// Quando o caranguejo normal é destruído (derrotado), criamos a animação de morte com explosãozinha
if (sprite_exists(spr_crab_death)) {
    safe_create_layer(x, y, "Instances", obj_enemy_death);
}
audio_play_sound(snd_enemy_death, 10, false);



