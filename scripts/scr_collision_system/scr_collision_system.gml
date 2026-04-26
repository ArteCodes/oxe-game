/// @function   CollisionSystem(layer_names, left, top, right, bottom)
/// @description Resolve colisao com uma ou mais layers de tilemap.
///              Passa um array com os nomes das layers — todas sao checadas em cada resolve.
///              Chame resolve_x e resolve_y antes de aplicar velocidade ao personagem.
///              Retorna 0 na direcao bloqueada por qualquer uma das layers.
/// @param {Array<string>} layer_names  Array com os nomes das layers de parede
///                                     Ex: ["Tiles_Wall", "Tiles_Wall_1"]
///                                     Tambem aceita uma string unica para compatibilidade
/// @param {real}          left         Distancia da origem ate a borda esquerda da hitbox
/// @param {real}          top          Distancia da origem ate a borda superior da hitbox
/// @param {real}          right        Distancia da origem ate a borda direita da hitbox
/// @param {real}          bottom       Distancia da origem ate a borda inferior da hitbox
function CollisionSystem(_layer_names, _left, _top, _right, _bottom) constructor {

    // Aceita string unica ou array — normaliza sempre para array
    if (is_string(_layer_names)) {
        _layer_names = [_layer_names];
    }

    tilemaps = [];
    for (var _i = 0; _i < array_length(_layer_names); _i++) {
        var _id = layer_tilemap_get_id(layer_get_id(_layer_names[_i]));
        array_push(tilemaps, _id);
    }

    left   = _left;
    top    = _top;
    right  = _right;
    bottom = _bottom;

    /// @function   _hits_any(px, py)
    /// @description Retorna true se qualquer tilemap tiver tile solido na posicao dada.
    /// @param {real} px  Posicao X a checar no mundo
    /// @param {real} py  Posicao Y a checar no mundo
    /// @returns {bool}
    static _hits_any = function(_px, _py) {
        for (var _i = 0; _i < array_length(tilemaps); _i++) {
            if (tilemap_get_at_pixel(tilemaps[_i], _px, _py) > 0) return true;
        }
        return false;
    };

    /// @function   resolve_x(x, y, vx)
    /// @description Verifica se aplicar vx causaria colisao horizontal em qualquer layer.
    ///              Testa multiplos pontos da hitbox para evitar tunneling em tiles pequenos.
    /// @param {real} x   Posicao X atual do personagem
    /// @param {real} y   Posicao Y atual do personagem
    /// @param {real} vx  Velocidade horizontal a aplicar
    /// @returns {real}   vx original se livre, 0 se colidiu
    static resolve_x = function(_x, _y, _vx) {
        if (_hits_any(_x + _vx + right,  _y - top)        ||
            _hits_any(_x + _vx + right,  _y + bottom)     ||
            _hits_any(_x + _vx + right,  _y - top / 2)    ||
            _hits_any(_x + _vx + right,  _y + bottom / 2) ||
            _hits_any(_x + _vx - left,   _y - top)        ||
            _hits_any(_x + _vx - left,   _y + bottom)     ||
            _hits_any(_x + _vx - left,   _y - top / 2)    ||
            _hits_any(_x + _vx - left,   _y + bottom / 2)) {
            return 0;
        }
        return _vx;
    };

    /// @function   resolve_y(x, y, vy)
    /// @description Verifica se aplicar vy causaria colisao vertical em qualquer layer.
    ///              Testa multiplos pontos da hitbox para evitar tunneling em tiles pequenos.
    /// @param {real} x   Posicao X atual do personagem
    /// @param {real} y   Posicao Y atual do personagem
    /// @param {real} vy  Velocidade vertical a aplicar
    /// @returns {real}   vy original se livre, 0 se colidiu
    static resolve_y = function(_x, _y, _vy) {
        if (_hits_any(_x + right,     _y + _vy - top)      ||
            _hits_any(_x + right,     _y + _vy + bottom)   ||
            _hits_any(_x - left,      _y + _vy - top)      ||
            _hits_any(_x - left,      _y + _vy + bottom)   ||
            _hits_any(_x + right / 2, _y + _vy - top)      ||
            _hits_any(_x + right / 2, _y + _vy + bottom)   ||
            _hits_any(_x - left / 2,  _y + _vy - top)      ||
            _hits_any(_x - left / 2,  _y + _vy + bottom))  {
            return 0;
        }
        return _vy;
    };
}
