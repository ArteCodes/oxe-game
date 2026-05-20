// --- Evento Desenhar (Draw) do obj_boss ---

// 1. Desenha o próprio Boss com os frames de animação adequados
draw_self();

// 2. Desenha os maravilhosos avisos visuais premium de preparação dos ataques especiais do Boss
if (enemy_ai != undefined) {
    enemy_ai.draw(self);
}
