// Inicialização da pata do boss
image_speed = 0.25; // Velocidade da animação ao sair do chão
image_index = 0;
depth = -110; // Desenha acima do jogador e de outros inimigos

// Aumenta o tamanho da pata para 1.8x (alinhado com a escala do boss)
image_xscale = 1.8;
image_yscale = 1.8;

has_damaged = false;
// Efeito de terra tremendo ao surgir
effect_create_above(ef_smoke, x, y, 1, c_gray);

