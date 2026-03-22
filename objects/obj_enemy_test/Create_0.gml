// Timer para atirar
shoot_timer    = 0;
shoot_interval = 120; // atira a cada 2 segundos

// Partícula de fumaca ao morrer (simples)
part_type = part_type_create();
part_type_shape(part_type, pt_shape_cloud);
part_type_size(part_type, 0.3, 0.8, -0.05, 0);
part_type_colour2(part_type, c_gray, c_dkgray);
part_type_alpha2(part_type, 1, 0);
part_type_speed(part_type, 1, 3, -0.1, 0);
part_type_direction(part_type, 0, 360, 0, 0);
part_type_life(part_type, 30, 60);