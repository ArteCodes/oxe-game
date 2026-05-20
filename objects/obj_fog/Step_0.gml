// --- Evento Etapa (Step) do obj_fog ---

// 1. Atualiza a posição de cada nuvem de neblina e faz loop de tela suave
var _w_margin = 600; // Margem para nuvens grandes não sumirem abruptamente nas bordas
var _h_margin = 600;

for (var i = 0; i < array_length(fog_clouds); i++) {
    var _c = fog_clouds[i];
    
    // Desloca conforme a velocidade do vento lento
    _c.x += _c.vx;
    _c.y += _c.vy;
    
    // Reposiciona na borda oposta se sair do mapa
    if (_c.x < -_w_margin) _c.x = room_width + _w_margin;
    if (_c.x > room_width + _w_margin) _c.x = -_w_margin;
    
    if (_c.y < -_h_margin) _c.y = room_height + _h_margin;
    if (_c.y > room_height + _h_margin) _c.y = -_h_margin;
}
