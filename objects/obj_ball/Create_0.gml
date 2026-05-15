// Velocidade inicial (sobrescrita pelo SlingshotSystem ao disparar)
vx = 0;
vy = 0;

// Física
initial_speed    = 8;   // velocidade de lançamento
max_distance     = 400; // alcance máximo em pixels (sobrescrito pelo SlingshotSystem)
distance_traveled = 0;  // distância já percorrida
speed_min        = 2;   // velocidade mínima antes de parar
bounce_decay     = 0.9; // fator de perda de velocidade a cada quique (não usado com decay linear)

// Coleta
collect_delay = 20; // frames antes de poder ser coletada (evita coleta instantânea)
owner         = noone; // referência ao obj_player que disparou

// Colisão com paredes
tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));

// Rastro visual — histórico das últimas posições
trail     = ds_list_create();
trail_max = 10;
// --- Evento Criar (Create) do obj_ball ---
movement = new MovementSystem(5, 0.5, 0.1); // Ajuste os valores como achar melhor para a pedra