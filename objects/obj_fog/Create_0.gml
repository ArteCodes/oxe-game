// --- Evento Criar (Create) do obj_fog ---

// 1. Configurações visuais e profundidade
depth = -90; // Desenha por cima do player e inimigos, mas sob o HUD

// 2. GERAÇÃO PROCEDURAL DO SPRITE DE NÚVEM DE NÉVOA
// Para evitar carregar arquivos externos, geramos uma textura de nuvem suave e realista
var _size = 256;
var _surf = surface_create(_size, _size);
surface_set_target(_surf);
draw_clear_alpha(c_white, 0);

// Desenha círculos concêntricos super suaves para criar degradê perfeito
for (var i = _size / 2; i > 0; i -= 2) {
    var _alpha = (1.0 - (i / (_size / 2))) * 0.09; // Densidade suave das bordas
    draw_set_alpha(_alpha);
    draw_circle_color(_size / 2, _size / 2, i, c_white, c_white, false);
}
draw_set_alpha(1.0);
surface_reset_target();

// Cria o sprite permanente e remove a superfície da memória
spr_fog_cloud = sprite_create_from_surface(_surf, 0, 0, _size, _size, false, false, _size / 2, _size / 2);
surface_free(_surf);

// 3. INICIALIZAÇÃO DA HORDAS DE NUVENS DE NEBLINA ATMOSFÉRICA
fog_clouds = [];
var _num_clouds = 18; // Preenche confortavelmente o mapa sem sobrecarregar

for (var j = 0; j < _num_clouds; j++) {
    // Espalha as nuvens aleatoriamente pelas dimensões estimadas do mapa
    var _rx = random(room_width);
    var _ry = random(room_height);
    
    array_push(fog_clouds, {
        x: _rx,
        y: _ry,
        vx: random_range(-0.12, 0.12), // Movimento horizontal super lento
        vy: random_range(-0.06, 0.06), // Movimento vertical super lento
        scale: random_range(2.5, 5.0), // Nuvens gigantescas cobrindo o mapa (até 1280px)
        alpha: random_range(0.06, 0.18), // Altamente translúcidas
        pulse_speed: random_range(0.015, 0.035),
        pulse_offset: random(100)
    });
}
