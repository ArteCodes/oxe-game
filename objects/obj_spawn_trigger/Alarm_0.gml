// Lógica de spawn sequencial
if (spawn_count > 0) {
    // Escolhe o tipo de caranguejo aleatoriamente (50% azul, 50% normal)
    var _tipo = choose(obj_enemy, obj_enemy_long);
    // 2. Calcula posição aleatória próxima ao gatilho com verificação rigorosa
    var _tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));
    var _spawn_x = x;
    var _spawn_y = y;
    var _success = false;

    repeat(10) {
        var _tx = x + irandom_range(-48, 48);
        var _ty = y + irandom_range(-48, 48);
        // Verifica se o ponto está livre de paredes
        if (tilemap_get_at_pixel(_tilemap, _tx, _ty) == 0) {
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
