// --- Evento Criar (Create) do obj_door_next ---
// Define para qual sala esse portal vai levar
if (room == rm_main_maps) {
    target_room = rm_new_room2;
} else {
    target_room = rm_main_maps;
}

// --- Estado do Portal ---
portal_active = false;    // O portal ainda não se abriu
enemies_detected = false; // Rastreia se inimigos foram detectados na sala
portal_opening = false;   // Animação de abertura em progresso
portal_closing = false;   // Animação de fechamento em progresso
portal_scale = 0;         // Escala do portal (0 = fechado, 1 = totalmente aberto)
portal_alpha = 0;         // Transparência geral do portal
portal_angle = 0;         // Rotação do anel externo
portal_pulse = 0;         // Timer para pulsação interna
portal_particles = [];    // Partículas decorativas de energia

// Profundidade visual: acima do chão mas abaixo do jogador
depth = 0;

// Remove o sprite de pedra herdado — o portal é desenhado 100% via código
sprite_index = -1;
