/// @function safe_create_layer(x, y, layer_name, object)
/// @description Cria uma instância em uma camada de forma segura, com fallback para Instances, a camada do próprio objeto chamador, ou por profundidade se nada mais funcionar.
function safe_create_layer(_x, _y, _layer_name, _object) {
    var _target_layer = -1;
    
    // 1. Verifica se a camada solicitada é válida
    if (is_string(_layer_name) && layer_exists(_layer_name)) {
        _target_layer = layer_get_id(_layer_name);
    } else if (layer_exists(_layer_name)) {
        _target_layer = _layer_name;
    }
    
    // 2. Fallback para "Instances"
    if (_target_layer == -1 && layer_exists("Instances")) {
        _target_layer = layer_get_id("Instances");
    }
    
    // 3. Fallback para a própria camada do objeto chamador (self.layer)
    if (_target_layer == -1 && variable_instance_exists(self, "layer") && layer != -1 && layer_exists(layer)) {
        _target_layer = layer;
    }
    
    // 4. Criação segura
    if (_target_layer != -1) {
        return instance_create_layer(_x, _y, _target_layer, _object);
    } else {
        // Fallback absoluto: cria usando profundidade
        var _depth = variable_instance_exists(self, "depth") ? depth : 0;
        return instance_create_depth(_x, _y, _depth, _object);
    }
}

/// @function CollisionSystem(_layer_name, _id_type_collision)
/// @description Sistema de colisão modular baseado em tipos pré-definidos.
/// @param {string} _layer_name       Nome da camada de tiles no editor.
/// @param {real}   _id_type_collision ID da máscara (1 = Cheia, 2 = Meia).
function CollisionSystem(_layer_name, _id_type_collision) constructor {

    #region Inicialização de Recursos
    // Obtém o ID do mapa de tiles da camada informada [6, 7]
    var _l_id = layer_get_id(_layer_name);
    tilemap = layer_tilemap_get_id(_l_id);
    #endregion

    #region Definição Interna de Offsets
    // Define as distâncias com base no ID recebido [1, 8]
    switch (_id_type_collision) {
        case 1: // TIPO 1: Colisão Cheia
            left   = 12;
            top    = 18;
            right  = 12;
            bottom = 12;
            break;

        case 2: // TIPO 2: Colisão Meia
            left   = 8;
            top    = 8;
            right  = 6;
            bottom = 6;
            break;

        default: // Configuração de segurança (caso o ID seja inválido)
            left   = 8;
            top    = 8;
            right  = 8;
            bottom = 8;
            break;
    }
    #endregion

    #region Métodos Estáticos (Comportamento)
    /// @function resolve_x(x, y, vx)
    static resolve_x = function(_x, _y, _vx) {
        // Verifica 8 pontos ao redor da máscara para evitar atravessar tiles [9]
        // tilemap_get_at_pixel > 0 considera qualquer tile presente como sólido [10]
        if (tilemap_get_at_pixel(tilemap, _x + _vx + right, _y - top)        > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + right, _y + bottom)     > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + right, _y - top/2)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + right, _y + bottom/2)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,  _y - top)        > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,  _y + bottom)     > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,  _y - top/2)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,  _y + bottom/2)   > 0) {
            return 0;
        }
        return _vx;
    };

    /// @function resolve_y(x, y, vy)
    static resolve_y = function(_x, _y, _vy) {
        if (tilemap_get_at_pixel(tilemap, _x + right,   _y + _vy - top)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x + right,   _y + _vy + bottom)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left,    _y + _vy - top)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left,    _y + _vy + bottom)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x + right/2, _y + _vy - top)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x + right/2, _y + _vy + bottom)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left/2,  _y + _vy - top)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left/2,  _y + _vy + bottom)   > 0) {
            return 0;
        }
        return _vy;
    };
    #endregion
}