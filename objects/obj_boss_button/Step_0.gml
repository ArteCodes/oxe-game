// --- Evento Etapa (Step) do obj_boss_button ---

// 1. LÓGICA DE REVELAÇÃO: Fica visível e ativo apenas quando o boss morrer
if (!visible) {
    if (instance_exists(obj_boss)) {
        boss_detected = true;
    }
    
    // Se o boss foi derrotado (ou se não há nenhum boss na sala)
    if (!instance_exists(obj_boss)) {
        visible = true;
        
        // Efeito premium de revelação na parede (anel de poeira e faíscas rubi)
        effect_create_above(ef_ring, x, y, 1, make_color_rgb(255, 30, 70));
        effect_create_above(ef_spark, x, y, 1, make_color_rgb(255, 100, 120));
    }
}

// 2. ATUALIZAÇÃO SÓ SE ESTIVER REVELADO
if (visible) {
    button_logic.update(self);
    image_blend = make_color_rgb(255, 30, 70); // Mantém a tonalidade rubi
}
