// --- Evento Criar (Create) do obj_dark_reveal ---
// Sistema de escuridão por ÁREAS: tudo começa preto.
// Quando o jogador entra numa área do mapa, a área inteira se revela de uma vez.

// Profundidade: desenha ACIMA de tudo (player, inimigos, fog) exceto o HUD/GUI
depth = -130;

// --- CONFIGURAÇÃO DO GRID DE RENDERIZAÇÃO (células pequenas para visual suave) ---
cell_size = 32;
grid_w = ceil(room_width / cell_size);
grid_h = ceil(room_height / cell_size);

// Grid de revelação: 0 = Escuro, 1 = Revelado
reveal_grid = ds_grid_create(grid_w, grid_h);
ds_grid_clear(reveal_grid, 0);

// --- CONFIGURAÇÃO DAS ÁREAS/ZONAS DO MAPA ---
// Cada "área" é um bloco grande do mapa (ex: 500x500 pixels).
// Quando o jogador pisa em qualquer ponto de uma área, a área INTEIRA se revela.
area_w = 500; // Largura de cada área em pixels
area_h = 500; // Altura de cada área em pixels

// Grid de áreas (controla quais áreas já foram visitadas)
areas_cols = ceil(room_width / area_w);
areas_rows = ceil(room_height / area_h);
area_visited = ds_grid_create(areas_cols, areas_rows);
ds_grid_clear(area_visited, 0);

// Superfície de renderização da máscara de escuridão
surf_dark = -1;
