// --- Evento Etapa (Step) do obj_boss_dead ---
// Congela no último frame para que ele fique permanentemente quebrado no chão
if (image_index >= image_number - 1) {
    image_speed = 0;
    image_index = image_number - 1;
}
