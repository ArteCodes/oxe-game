/// @function   CollisionSystem(tilemap_layer_name, sprite_width, sprite_height)
/// @description Gerencia colisao do personagem com tiles de parede.
///              Checa os 4 cantos do sprite antes de aplicar o movimento.
///              Usado pelo obj_player e pelo DodgeSystem.
/// @param {string} tilemap_layer_name  Nome da camada de tiles na room
/// @param {real}   sprite_width        Largura do sprite em pixels
/// @param {real}   sprite_height       Altura do sprite em pixels
function CollisionSystem(_layer_name, _sprite_width, _sprite_height) constructor {

    tilemap = layer_tilemap_get_id(layer_get_id(_layer_name));
    w = _sprite_width;
    h = _sprite_height;

    /// @function   resolve_x(x, y, vx)
    /// @description Checa colisao horizontal nos 4 cantos do sprite.
    ///              Retorna vx zerado se algum canto colidir com um tile.
    /// @param {real} x   Posicao X atual do personagem
    /// @param {real} y   Posicao Y atual do personagem
    /// @param {real} vx  Velocidade horizontal a aplicar
    /// @returns {real}   vx original ou 0 se colidir
    static resolve_x = function(_x, _y, _vx) {
        if (tilemap_get_at_pixel(tilemap, _x + _vx + w, _y + 0) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + w, _y + h) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + 0, _y + 0) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + _vx + 0, _y + h) > 0) {
            return 0;
        }
        return _vx;
    };

    /// @function   resolve_y(x, y, vy)
    /// @description Checa colisao vertical nos 4 cantos do sprite.
    ///              Retorna vy zerado se algum canto colidir com um tile.
    /// @param {real} x   Posicao X atual do personagem
    /// @param {real} y   Posicao Y atual do personagem
    /// @param {real} vy  Velocidade vertical a aplicar
    /// @returns {real}   vy original ou 0 se colidir
    static resolve_y = function(_x, _y, _vy) {
        if (tilemap_get_at_pixel(tilemap, _x + 0, _y + _vy + h) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + w, _y + _vy + h) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + 0, _y + _vy + 0) > 0 ||
            tilemap_get_at_pixel(tilemap, _x + w, _y + _vy + 0) > 0) {
            return 0;
        }
        return _vy;
    };

}