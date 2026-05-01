// 1. Spawna o segundo: 300 pixels à ESQUERDA (x-) e ACIMA (y-)
instance_create_layer(x - 300, y - 300, "Instances", obj_enemy);

// 2. Agora sim, destrói o gatilho, pois a sequência terminou [7]
instance_destroy();