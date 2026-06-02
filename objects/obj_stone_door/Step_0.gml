// 1. INICIALIZAÇÃO DINÂMICA (Roda no primeiro Step para segurança)
if (!initialized) {
    // Busca a camada de colisão padrão do jogo
    var _lay = layer_get_id("Tiles_Wall");
    if (_lay != -1) {
        tilemap = layer_tilemap_get_id(_lay);
    }
    
    // Determina a distância do deslize com base no tamanho do sprite se for -1
    var _dist = slide_distance;
    if (_dist == -1) {
        if (slide_direction == "left" || slide_direction == "right") {
            _dist = sprite_width;
        } else {
            _dist = sprite_height;
        }
    }
    
    // Calcula o ponto final (alvo) de acordo com a direção escolhida
    if (slide_direction == "left") {
        x_open = x_start - _dist;
    } else if (slide_direction == "right") {
        x_open = x_start + _dist;
    } else if (slide_direction == "up") {
        y_open = y_start - _dist;
    } else if (slide_direction == "down") {
        y_open = y_start + _dist;
    }
    
    // Garante que o estado de colisão inicial está marcado como fechado
    // se estiver na posição inicial
    if (x == x_start && y == y_start) {
        scr_set_door_collision(x_start, y_start, true);
        tiles_marked = true;
    }
    
    initialized = true;
}

// 2. VERIFICA BOTÕES ASSOCIADOS: Varre os botões para ver se a porta deve abrir
var _any_active = false;
with (obj_stone_button) {
    if (door_id == other.door_id && is_active) {
        _any_active = true;
    }
}

// 3. DEFINE ALVO E DESLIZA:
var _target_x = _any_active ? x_open : x_start;
var _target_y = _any_active ? y_open : y_start;

// Movimenta suavemente usando aproximação (limita a velocidade constante)
if (x != _target_x) {
    x += clamp(_target_x - x, -slide_speed, slide_speed);
}
if (y != _target_y) {
    y += clamp(_target_y - y, -slide_speed, slide_speed);
}

// 4. ATUALIZA A COLISÃO DO GRID DE TILES (PLAYER / INIMIGOS / BOLA):
// Se a porta se mover de sua posição de origem, ela desativa o tile de colisão
var _is_fully_closed = (x == x_start && y == y_start);

if (_is_fully_closed) {
    if (!tiles_marked) {
        scr_set_door_collision(x_start, y_start, true);
        tiles_marked = true;
        // Efeito premium de fechamento (poeira no chão ao bater)
        effect_create_above(ef_smoke, x + sprite_width/2, y + sprite_height/2, 0.4, c_gray);
    }
} else {
    if (tiles_marked) {
        scr_set_door_collision(x_start, y_start, false);
        tiles_marked = false;
        // Efeito premium de início de abertura (faíscas/fumaça de atrito)
        effect_create_above(ef_smoke, x + sprite_width/2, y + sprite_height/2, 0.2, c_lightgray);
    }
}
