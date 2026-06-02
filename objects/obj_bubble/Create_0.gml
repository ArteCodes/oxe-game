// --- Evento Criar (Create) ---
vx = 0;
vy = 0;
collision = new CollisionSystem("Tiles_Wall", 1);

// Lista para o rastro visual
trail_list = ds_list_create();
trail_max = 8;
safe_timer = 5; // Evita colidir com a parede onde o caranguejo está encostado nos primeiros 5 frames

// Ricochete e Alcance
max_distance = 400;
distance_traveled = 0;
tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));
