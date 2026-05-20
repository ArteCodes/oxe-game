// --- Evento Desenhar (Draw) do obj_dark_reveal ---
// Desenha uma máscara de escuridão total sobre o mapa.
// Apenas as áreas onde o jogador JÁ PASSOU ficam reveladas permanentemente.

// 1. OBTÉM AS COORDENADAS E DIMENSÕES DA CÂMERA ATIVA
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

// 2. CRIA OU REDIMENSIONA A SUPERFÍCIE DA ESCURIDÃO
if (!surface_exists(surf_dark)) {
    surf_dark = surface_create(_cw, _ch);
} else if (surface_get_width(surf_dark) != _cw || surface_get_height(surf_dark) != _ch) {
    surface_free(surf_dark);
    surf_dark = surface_create(_cw, _ch);
}

// 3. RENDERIZA A MÁSCARA DE ESCURIDÃO
if (surface_exists(surf_dark)) {
    surface_set_target(surf_dark);
    
    // Preenche a superfície inteira de preto opaco total — tudo escuro por padrão
    draw_clear_alpha(c_black, 1.0);
    
    // Usa Blend Mode Subtract para "recortar" buracos nas áreas reveladas
    gpu_set_blendmode(bm_subtract);
    
    // Calcula quais células do grid estão visíveis na câmera (otimização de performance)
    var _start_gx = max(0, floor(_cx / cell_size) - 1);
    var _start_gy = max(0, floor(_cy / cell_size) - 1);
    var _end_gx   = min(grid_w - 1, floor((_cx + _cw) / cell_size) + 1);
    var _end_gy   = min(grid_h - 1, floor((_cy + _ch) / cell_size) + 1);
    
    // Itera APENAS pelas células visíveis na câmera (não o mapa inteiro)
    for (var _gx = _start_gx; _gx <= _end_gx; _gx++) {
        for (var _gy = _start_gy; _gy <= _end_gy; _gy++) {
            if (ds_grid_get(reveal_grid, _gx, _gy) == 1) {
                // Converte a posição do grid para posição relativa à câmera
                var _rx = (_gx * cell_size + cell_size / 2) - _cx;
                var _ry = (_gy * cell_size + cell_size / 2) - _cy;
                
                // Desenha um círculo branco com degradê para revelar suavemente a área
                draw_circle_color(_rx, _ry, cell_size * 1.2, c_white, c_black, false);
            }
        }
    }
    
    // Desenha uma luz mais forte e suave ao redor da posição ATUAL do jogador
    // para dar um efeito de "lanterna viva" sobre as áreas já reveladas
    if (instance_exists(obj_player)) {
        var _px = obj_player.x - _cx;
        var _py = obj_player.y - _cy;
        
        // Pulsação suave da lanterna do jogador
        var _pulse = sin(current_time * 0.003) * 8;
        var _r = reveal_radius + _pulse;
        
        // Círculo principal de revelação do jogador
        draw_circle_color(_px, _py, _r, c_white, c_black, false);
        // Intensifica a visibilidade bem próxima ao jogador
        draw_circle_color(_px, _py, _r * 0.4, c_white, c_black, false);
    }
    
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    
    // Desenha a máscara de escuridão sobre toda a câmera
    draw_surface(surf_dark, _cx, _cy);
}
