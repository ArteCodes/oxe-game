// --- Evento Desenhar (Draw) do obj_fog ---

// 1. Renderiza cada nuvem de névoa aplicando pulsação e mesclagem suave
if (sprite_exists(spr_fog_cloud)) {
    for (var i = 0; i < array_length(fog_clouds); i++) {
        var _c = fog_clouds[i];
        
        // Pulsação senoidal da transparência com base no tempo de execução do jogo
        var _time_val = (current_time * _c.pulse_speed) + _c.pulse_offset;
        var _dynamic_alpha = _c.alpha + sin(_time_val) * (_c.alpha * 0.22);
        
        // Desenha a nuvem translúcida cinza/branca atmosférica
        draw_sprite_ext(
            spr_fog_cloud, 0,
            _c.x, _c.y,
            _c.scale, _c.scale,
            0, c_white, clamp(_dynamic_alpha, 0.01, 0.32)
        );
    }
}
