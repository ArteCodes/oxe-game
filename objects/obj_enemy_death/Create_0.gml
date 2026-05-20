 // --- Evento Criar (Create) ---
sprite_index = spr_crab_death;
image_index = 0;
image_speed = 0.25; // Velocidade suave da animação de morte

// Cria uma "explosãozinha" branca e bem menor no momento da morte!
effect_create_above(ef_ring, x, y, 0, c_white); // Anel de choque pequeno e branco
effect_create_above(ef_smoke, x, y, 0, c_white); // Fumacinha branca pequena
