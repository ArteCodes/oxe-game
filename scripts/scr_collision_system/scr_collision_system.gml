/// @function   CollisionSystem(layer_name, left, top, right, bottom)
/// @description Resolve colisao com tilemap para movimento e deslize.
///              Chame resolve_x e resolve_y antes de aplicar velocidade ao personagem.
///              Retorna 0 na direcao bloqueada — nao aplica a velocidade, o chamador decide.
/// @param {string} layer_name  Nome da layer de tiles de parede (ex: "Tiles_Walls")
/// @param {real}   left        Distancia da origem do objeto ate a borda esquerda da hitbox
/// @param {real}   top         Distancia da origem do objeto ate a borda superior da hitbox
/// @param {real}   right       Distancia da origem do objeto ate a borda direita da hitbox
/// @param {real}   bottom      Distancia da origem do objeto ate a borda inferior da hitbox
function CollisionSystem(_layer_name, _left, _top, _right, _bottom) constructor {

    tilemap = layer_tilemap_get_id(layer_get_id(_layer_name));
    left    = _left;
    top     = _top;
    right   = _right;
    bottom  = _bottom;

    /// @function   resolve_x(x, y, vx)
    /// @description Verifica se aplicar vx causaria colisao horizontal.
    ///              Testa multiplos pontos da hitbox para evitar tunneling em tiles pequenos.
    /// @param {real} x   Posicao X atual do personagem
    /// @param {real} y   Posicao Y atual do personagem
    /// @param {real} vx  Velocidade horizontal a aplicar
    /// @returns {real}   vx original se livre, 0 se colidiu
    static resolve_x = function(_x, _y, _vx) {
        if (tilemap_get_at_pixel(tilemap, _x + _vx + right,  _y - top)       > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + right,  _y + bottom)    > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + right,  _y - top / 2)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + right,  _y + bottom / 2) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,   _y - top)       > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,   _y + bottom)    > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,   _y - top / 2)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx - left,   _y + bottom / 2) > 0) {
            return 0;
        }
        return _vx;
    };

    /// @function   resolve_y(x, y, vy)
    /// @description Verifica se aplicar vy causaria colisao vertical.
    ///              Testa multiplos pontos da hitbox para evitar tunneling em tiles pequenos.
    /// @param {real} x   Posicao X atual do personagem
    /// @param {real} y   Posicao Y atual do personagem
    /// @param {real} vy  Velocidade vertical a aplicar
    /// @returns {real}   vy original se livre, 0 se colidiu
    static resolve_y = function(_x, _y, _vy) {
        if (tilemap_get_at_pixel(tilemap, _x + right,    _y + _vy - top)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x + right,    _y + _vy + bottom)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left,     _y + _vy - top)      > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left,     _y + _vy + bottom)   > 0 ||
            tilemap_get_at_pixel(tilemap, _x + right / 2, _y + _vy - top)     > 0 ||
            tilemap_get_at_pixel(tilemap, _x + right / 2, _y + _vy + bottom)  > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left / 2,  _y + _vy - top)     > 0 ||
            tilemap_get_at_pixel(tilemap, _x - left / 2,  _y + _vy + bottom)  > 0) {
            return 0;
        }
        return _vy;
    };
}
