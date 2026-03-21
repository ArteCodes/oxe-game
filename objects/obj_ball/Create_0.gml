vx = 0;
vy = 0;

collect_delay = 20;
speed_min    = 2;  // velocidade mínima antes de parar
bounce_decay = 0.9;  // perde 10% da velocidade a cada quique
owner        = noone; // referência ao obj_player dono
max_distance = 400; // distância máxima em pixels
distance_traveled = 0; // distância percorrida
initial_speed = 8; // velocidade máxima ao lançar

tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));

// Rastro — histórico das últimas posições
trail = ds_list_create();
trail_max = 10;