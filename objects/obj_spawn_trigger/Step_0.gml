if (!spawn_iniciado && instance_place(x, y, obj_player)) {
    
    // 1. Spawna o primeiro: 200 pixels à DIREITA (x+) e ACIMA (y-)
    instance_create_layer(x + 300, y + 200, "Instances", obj_enemy);
    
    // Marca que o processo iniciou para não repetir este bloco
    spawn_iniciado = true;
    
    // 2. Define o alarme para 2 segundos (60 frames por segundo * 2 = 120)
    alarm = 120; 
}