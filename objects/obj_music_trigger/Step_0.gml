// --- Lógica de Gatilho de Música ---
// Se o player passar pelo gatilho, troca a música de fundo e se destrói
var _player = instance_place(x, y, obj_player);
if (_player != noone) {
    play_bgm(music_to_play);
    instance_destroy();
}
