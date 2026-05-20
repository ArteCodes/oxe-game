// --- Evento Etapa (Step) do obj_dark_reveal ---
// Detecta em qual ÁREA do mapa o jogador está.
// Se for uma área nova (nunca visitada), revela TODAS as células dessa área de uma vez.

if (instance_exists(obj_player)) {
    // Calcula em qual área/zona do mapa o jogador está agora
    var _ax = clamp(floor(obj_player.x / area_w), 0, areas_cols - 1);
    var _ay = clamp(floor(obj_player.y / area_h), 0, areas_rows - 1);
    
    // Se essa área ainda NÃO foi visitada, revela ela inteira de uma vez
    if (ds_grid_get(area_visited, _ax, _ay) == 0) {
        // Marca a área como visitada
        ds_grid_set(area_visited, _ax, _ay, 1);
        
        // Calcula os limites da área em pixels
        var _area_left   = _ax * area_w;
        var _area_top    = _ay * area_h;
        var _area_right  = min((_ax + 1) * area_w, room_width);
        var _area_bottom = min((_ay + 1) * area_h, room_height);
        
        // Converte para coordenadas do grid de células pequenas
        var _cell_left   = floor(_area_left / cell_size);
        var _cell_top    = floor(_area_top / cell_size);
        var _cell_right  = min(ceil(_area_right / cell_size), grid_w - 1);
        var _cell_bottom = min(ceil(_area_bottom / cell_size), grid_h - 1);
        
        // Revela TODAS as células dentro dessa área de uma vez
        for (var _gx = _cell_left; _gx <= _cell_right; _gx++) {
            for (var _gy = _cell_top; _gy <= _cell_bottom; _gy++) {
                ds_grid_set(reveal_grid, _gx, _gy, 1);
            }
        }
    }
}
