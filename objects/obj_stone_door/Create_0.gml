// Variáveis configuráveis na aba de variáveis de instância no editor de salas
door_id = "default"; // Deve corresponder ao door_id do botão
slide_direction = "right"; // Direção para deslizar: "left", "right", "up", "down"
slide_speed = 2; // Velocidade com que a porta se move (em pixels por frame)
slide_distance = -1; // Distância em pixels. Se -1, usa a largura/altura do sprite

// Posições e controle físico
x_start = x;
y_start = y;
x_open = x;
y_open = y;

is_open = false;
tiles_marked = false;
tilemap = noone;

// Aguarda o primeiro frame para calcular a posição de alvo correta
// e garantir que os layers da sala estejam carregados
initialized = false;

// Função membro para marcar ou desmarcar a colisão no grid de Tiles
scr_set_door_collision = function(_x, _y, _set) {
    // Busca novamente o tilemap se ele estiver inválido ou não inicializado
    if (tilemap == noone || !layer_tilemap_exists("Tiles_Wall", tilemap)) {
        var _lay = layer_get_id("Tiles_Wall");
        if (_lay != -1) {
            tilemap = layer_tilemap_get_id(_lay);
        }
    }
    
    if (tilemap != noone && tilemap != -1) {
        var _tw = 32; // tamanho padrão dos tiles
        var _th = 32;
        
        // Calcula as extremidades da Bounding Box correspondentes à posição fechada
        var _left   = bbox_left - x + _x;
        var _top    = bbox_top - y + _y;
        var _right  = bbox_right - x + _x;
        var _bottom = bbox_bottom - y + _y;
        
        var _start_col = floor(_left / _tw);
        var _end_col   = floor(_right / _tw);
        var _start_row = floor(_top / _th);
        var _end_row   = floor(_bottom / _th);
        
        for (var _col = _start_col; _col <= _end_col; _col++) {
            for (var _row = _start_row; _row <= _end_row; _row++) {
                if (_set) {
                    // Define o tile como sólido (index 1)
                    tilemap_set(tilemap, 1, _col, _row);
                } else {
                    // Limpa o tile de colisão (index 0)
                    tilemap_set(tilemap, 0, _col, _row);
                }
            }
        }
    }
}
