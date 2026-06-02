 // --- Evento Create do obj_final_boss_npc ---
event_inherited(); 

state = "statue"; // "statue", "glowing", "active"
sprite_index = spr_final_boss_statue;
image_index = 0;
image_speed = 0;

dialogue_started = false;

falas = [
    "REI CARANGUEJO: Oh! Voce finalmente quebrou a terrivel maldicao que me aprisionava nesta estatua de pedra!",
    "REI CARANGUEJO: Muito obrigado, nobre guerreiro do estilingue! O nosso reino dos caranguejos esta salvo!",
    "REI CARANGUEJO: Gracas a sua coragem incomensuravel, a paz retornara as nossas praias de areia dourada.",
    "REI CARANGUEJO: Sua gloriosa jornada termina com a vitoria absoluta!"
];

/// @function interagir()
interagir = function() {
    if (state == "statue") {
        state = "glowing";
        sprite_index = spr_final_boss_glow;
        image_index = 0;
        image_speed = 0.15; // Velocidade lenta e bonita de transição
        return false; // Retorna false para não abrir o diálogo imediatamente
    }
    return false; // Se já estiver brilhando ou ativo, o diálogo é autônomo
}
