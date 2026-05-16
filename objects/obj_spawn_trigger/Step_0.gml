// Ativa o spawner quando o jogador encostar
if (!spawn_iniciado && instance_place(x, y, obj_player)) {
    spawn_iniciado = true;
    alarm[0] = 1; // Dispara o primeiro spawn imediatamente
}