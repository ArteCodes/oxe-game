/// @description Sistema de Navegação Simples (Desvio de Paredes)

function path_system_init() {
    // Não precisamos mais de grid para esse sistema simplificado
}

function path_system_update_instance(_inst, _target_x, _target_y, _speed) {
    // Usamos mp_potential_step que é muito mais robusto para desviar de obstáculos
    // Como as paredes são Tiles, usamos a detecção de colisão que já temos
    
    var _dir_to_player = point_direction(_inst.x, _inst.y, _target_x, _target_y);
    
    // Se não há colisão direta no caminho, vai reto (mais inteligente)
    if (!collision_line(_inst.x, _inst.y, _target_x, _target_y, obj_enemy_parent, false, true)) {
         _inst.movement.vx = lengthdir_x(_speed, _dir_to_player);
         _inst.movement.vy = lengthdir_y(_speed, _dir_to_player);
         return true;
    }
    
    // Se houver algo no caminho, tentamos um desvio simples
    // Gira a direção até achar um caminho livre
    for (var i = 0; i < 90; i += 10) {
        for (var _s = -1; _s <= 1; _s += 2) {
            var _test_dir = _dir_to_player + (i * _s);
            var _tx = _inst.x + lengthdir_x(16, _test_dir);
            var _ty = _inst.y + lengthdir_y(16, _test_dir);
            
            // Verifica se o ponto de teste está livre de parede (usando o tilemap)
            var _tilemap = layer_tilemap_get_id(layer_get_id("Tiles_Wall"));
            if (tilemap_get_at_pixel(_tilemap, _tx, _ty) == 0) {
                _inst.movement.vx = lengthdir_x(_speed, _test_dir);
                _inst.movement.vy = lengthdir_y(_speed, _test_dir);
                return true;
            }
        }
    }
    
    return false;
}
