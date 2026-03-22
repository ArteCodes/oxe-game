/// @function   AimSystem(tilemap_layer_name)
/// @description Simula e desenha a trajetoria da bolinha com quiques.
///              So aparece durante o carregamento do estilingue.
/// @param {string} tilemap_layer_name  Nome da camada de tiles de parede
function AimSystem(_layer_name) constructor {

    tilemap = layer_tilemap_get_id(layer_get_id(_layer_name));

    max_bounces = 5; // maximo de quiques simulados

    /// @function   draw(ox, oy, tx, ty, speed, distance)
    /// @description Simula e desenha a trajetoria completa.
    /// @param {real} ox        X do jogador (origem)
    /// @param {real} oy        Y do jogador (origem)
    /// @param {real} tx        X do alvo (mouse)
    /// @param {real} ty        Y do alvo (mouse)
    /// @param {real} speed     Velocidade do tiro atual
    /// @param {real} distance  Alcance total do tiro atual
    static draw = function(_ox, _oy, _tx, _ty, _speed, _distance) {
        var _dir = point_direction(_ox, _oy, _tx, _ty);
        var _vx  = lengthdir_x(_speed, _dir);
        var _vy  = lengthdir_y(_speed, _dir);

        var _px  = _ox;
        var _py  = _oy;
        var _dist_traveled = 0;
        var _bounces = 0;

        while (_dist_traveled < _distance && _bounces <= max_bounces) {
            var _ratio        = 1 - (_dist_traveled / _distance);
            var _cur_speed    = _speed * _ratio;

            // Checa ricochete horizontal
            if (tilemap_get_at_pixel(tilemap, _px + _vx + 4, _py) > 0 ||
                tilemap_get_at_pixel(tilemap, _px + _vx - 4, _py) > 0) {
                _vx = -_vx;
                _bounces++;

                // Marca ponto de quique
                draw_set_color(c_white);
                draw_circle(_px, _py, 3, false);
            }

            // Checa ricochete vertical
            if (tilemap_get_at_pixel(tilemap, _px, _py + _vy + 4) > 0 ||
                tilemap_get_at_pixel(tilemap, _px, _py + _vy - 4) > 0) {
                _vy = -_vy;
                _bounces++;

                draw_set_color(c_white);
                draw_circle(_px, _py, 3, false);
            }

            // Normaliza direcao e aplica velocidade atual
            var _cur_dir = point_direction(0, 0, _vx, _vy);
            if (_vx != 0 || _vy != 0) {
                _vx = lengthdir_x(_cur_speed, _cur_dir);
                _vy = lengthdir_y(_cur_speed, _cur_dir);
            }

            var _next_px = _px + _vx;
            var _next_py = _py + _vy;

            // Desenha segmento da linha
            var _alpha = _ratio * 0.8;
            draw_set_alpha(_alpha);
            draw_set_color(c_yellow);
            draw_line_width(_px, _py, _next_px, _next_py, 3);

            _px = _next_px;
            _py = _next_py;
            _dist_traveled += _cur_speed;
        }

        draw_set_alpha(1);
    };

}