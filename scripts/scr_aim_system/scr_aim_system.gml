/// @function   AimSystem(tilemap_layer_name)
/// @description Simula e desenha a trajetoria da bolinha com quiques.
///              So aparece durante o carregamento do estilingue.
///              Chame init() no Create do objeto apos instanciar o sistema.
/// @param {string} tilemap_layer_name  Nome da camada de tiles de parede
function AimSystem(_layer_name) constructor {

    _layer_name_ref = _layer_name; // guardado para init()
    tilemap         = -1;          // resolvido em init() — nao no constructor
    max_bounces     = 3;           // maximo de quiques simulados na previsao

    /// @function   init()
    /// @description Resolve o id do tilemap a partir do nome da layer.
    ///              Deve ser chamado no Create Event do objeto, apos o Room estar carregado.
    ///              Separado do constructor para evitar crash caso a layer ainda nao exista.
    static init = function() {
        tilemap = layer_tilemap_get_id(layer_get_id(_layer_name_ref));
    };

    /// @function   draw(ox, oy, tx, ty, speed, distance)
    /// @description Simula a trajetoria no papel e desenha sem criar objetos.
    ///              O alcance se ajusta automaticamente ao tiro rapido ou carregado.
    ///              Nao desenha nada se init() ainda nao foi chamado.
    /// @param {real} ox        X do jogador (origem do tiro)
    /// @param {real} oy        Y do jogador (origem do tiro)
    /// @param {real} tx        X do alvo (posicao do mouse)
    /// @param {real} ty        Y do alvo (posicao do mouse)
    /// @param {real} speed     Velocidade inicial do tiro
    /// @param {real} distance  Alcance total do tiro
    static draw = function(_ox, _oy, _tx, _ty, _speed, _distance) {
        if (tilemap == -1) return; // init() ainda nao foi chamado

        var _dir = point_direction(_ox, _oy, _tx, _ty);
        var _vx  = lengthdir_x(_speed, _dir);
        var _vy  = lengthdir_y(_speed, _dir);

        var _px            = _ox;
        var _py            = _oy;
        var _dist_traveled = 0;
        var _bounces       = 0;

        while (_dist_traveled < _distance && _bounces <= max_bounces) {

            var _ratio     = 1 - (_dist_traveled / _distance);
            var _cur_speed = _speed * _ratio;

            // --- Ricochete horizontal ---
            if (tilemap_get_at_pixel(tilemap, _px + _vx + 4, _py) > 0 ||
                tilemap_get_at_pixel(tilemap, _px + _vx - 4, _py) > 0) {
                _vx = -_vx;
                _bounces++;
                draw_set_alpha(1);
                draw_set_color(c_white);
                draw_circle(_px, _py, 3, false);
            }

            // --- Ricochete vertical ---
            if (tilemap_get_at_pixel(tilemap, _px, _py + _vy + 4) > 0 ||
                tilemap_get_at_pixel(tilemap, _px, _py + _vy - 4) > 0) {
                _vy = -_vy;
                _bounces++;
                draw_set_alpha(1);
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

            // Linha com fade conforme distancia restante
            draw_set_alpha(_ratio * 0.8);
            draw_set_color(c_white);
            draw_line_width(_px, _py, _next_px, _next_py, 3);

            _px = _next_px;
            _py = _next_py;
            _dist_traveled += _cur_speed;
        }

        draw_set_alpha(1);
    };
}
