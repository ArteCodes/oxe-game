// Lógica de spawn sequencial
if (spawn_count > 0) {
    // Escolhe o tipo de caranguejo aleatoriamente (normal, azul ou vermelho)
    var _tipo = choose(obj_enemy, obj_enemy_long, obj_enemy_red);
    // 2. Calcula posição aleatória próxima aos barris no meio do mapa (Coordenadas fornecidas pelo usuário)
    var _tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));
    
    // Coordenada específica do meio da sala dos barris
    var _spawn_x = 529;
    var _spawn_y = 1422;

    var _success = false;
    repeat(20) { // Aumentado para 20 tentativas para garantir um bom lugar
        var _tx = _spawn_x + irandom_range(-64, 64);
        var _ty = _spawn_y + irandom_range(-64, 64);
        // Verifica se o ponto está livre de paredes e dentro dos limites da sala
        if (tilemap_get_at_pixel(_tilemap, _tx, _ty) == 0 && _tx > 32 && _tx < room_width - 32 && _ty > 32 && _ty < room_height - 32) {
            _spawn_x = _tx;
            _spawn_y = _ty;
            _success = true;
            break;
        }
    }
    
    // 3. Cria o inimigo
    var _inst = instance_create_layer(_spawn_x, _spawn_y, "Instances", _tipo);
    
    // Força visibilidade e profundidade logo no spawn
    _inst.visible = true;
    _inst.depth = -50;
    
    spawn_count--; // Diminui o contador
    
    // Se ainda restarem inimigos, agenda o próximo
    if (spawn_count > 0) {
        alarm[0] = spawn_timer;
    }
}
