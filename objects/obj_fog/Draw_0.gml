// --- Evento Desenhar (Draw) do obj_fog ---

// 1. OBTÉM AS COORDENADAS E DIMENSÕES DA CÂMERA ATIVA
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

// 2. CRIA OU REDIMENSIONA A SUPERFÍCIE SE HOUVER MUDANÇA NA JANELA (EVITA MEMORY LEAKS E DISTORÇÕES)
if (!surface_exists(surf_fog)) {
    surf_fog = surface_create(_cw, _ch);
} else if (surface_get_width(surf_fog) != _cw || surface_get_height(surf_fog) != _ch) {
    surface_free(surf_fog);
    surf_fog = surface_create(_cw, _ch);
}

// 3. DESENHA A MÁSCARA DE ESCURIDÃO ATMOSFÉRICA
if (surface_exists(surf_fog)) {
    surface_set_target(surf_fog);
    
    // Limpa com um azul-marinho profundo translúcido (40% de opacidade)
    // O jogador consegue ver parcialmente além do seu campo de visão
    var _deep_dark_color = make_color_rgb(5, 7, 14);
    draw_clear_alpha(_deep_dark_color, 0.40);
    
    // Recorta o campo de visão do jogador usando Blend Mode Subtract
    gpu_set_blendmode(bm_subtract);
    if (instance_exists(obj_player)) {
        var _px = obj_player.x - _cx;
        var _py = obj_player.y - _cy;
        
        // Pulsação suave (simula respiração/lanterna)
        var _pulse = sin(current_time * 0.002) * 12;
        var _radius = 240 + _pulse; // Raio de visão aproximado do player
        
        // Desenha o círculo de luz com degradê radial (branco centro = totalmente revelado, preto borda = escuro)
        draw_circle_color(_px, _py, _radius, c_white, c_black, false);
        
        // Intensifica a luz bem no pé do jogador para visibilidade nítida próxima
        draw_circle_color(_px, _py, _radius * 0.45, c_white, c_black, false);
    }
    gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
    
    // Desenha a superfície da máscara de escuridão cobrindo toda a câmera
    draw_surface(surf_fog, _cx, _cy);
}

// 4. DESENHA AS NUVENS DE NEBLINA POR CIMA DA ESCURIDÃO (MÁXIMA ATMOSFERA E PROFUNDIDADE)
if (sprite_exists(spr_fog_cloud)) {
    for (var i = 0; i < array_length(fog_clouds); i++) {
        var _c = fog_clouds[i];
        
        // Pulsação de transparência individual
        var _time_val = (current_time * _c.pulse_speed) + _c.pulse_offset;
        var _dynamic_alpha = _c.alpha + sin(_time_val) * (_c.alpha * 0.22);
        
        // Desenha as nuvens gigantes flutuando lentamente sobre o cenário escuro
        draw_sprite_ext(
            spr_fog_cloud, 0,
            _c.x, _c.y,
            _c.scale, _c.scale,
            0, c_white, clamp(_dynamic_alpha, 0.01, 0.28)
        );
    }
}
