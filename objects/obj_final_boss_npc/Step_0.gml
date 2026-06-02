// --- Evento Step do obj_final_boss_npc ---

if (state == "glowing") {
    // Se a animação chegou ao fim
    if (image_index >= image_number - 1) {
        state = "active";
        sprite_index = spr_final_boss_active;
        image_index = 0;
        image_speed = 0.15; // Loop de animação sutil do caranguejo ativo
        
        // Inicia o diálogo automaticamente no player
        if (instance_exists(obj_player)) {
            obj_player.npc_foco = id;
            obj_player.dialogo.iniciar(falas);
            dialogue_started = true;
        }
    }
}
else if (state == "active") {
    // Quando o diálogo terminar (o balão fechar), vai para a tela de vitória
    if (dialogue_started && instance_exists(obj_player)) {
        if (!obj_player.dialogo.ativo) {
            room_goto(rm_victory);
        }
    }
}
