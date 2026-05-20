 // --- Evento Etapa (Step) ---
// Quando chegar no último frame da animação de morte, destrói o objeto
if (image_index >= image_number - 1) {
    instance_destroy();
}
