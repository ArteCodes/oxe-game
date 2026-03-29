/// @function   BallPhysicsSystem(layer_name)
/// @description Gerencia fisica, ricochete e parada da bolinha no mundo.
///              Chame init() no Create Event do obj_ball apos o Room estar carregado.
///              Chame update() todo Step passando a instancia do obj_ball.
/// @param {string} layer_name  Nome da layer de tiles de parede (ex: "Tiles_Wall")
function BallPhysicsSystem(_layer_name) constructor {

    _layer_name_ref = _layer_name;
    tilemap         = -1; // resolvido em init()

    /// @function   init()
    /// @description Resolve o id do tilemap. Chamar no Create Event apos o Room carregar.
    static init = function() {
        tilemap = layer_tilemap_get_id(layer_get_id(_layer_name_ref));
    };

    /// @function   update(ball)
    /// @description Executa um frame de fisica da bolinha.
    ///              Aplica decaimento de velocidade, ricochete e parada ao atingir o alcance.
    ///              Avisa o BallSystem do owner quando a bolinha para.
    /// @param {Id.Instance} ball  Referencia ao obj_ball sendo simulado
    /// @returns {bool} true se a bolinha parou neste frame
    static update = function(_ball) {
        if (tilemap == -1) return false;

        // Velocidade decai linearmente com a distancia restante
        var _ratio         = 1 - (_ball.distance_traveled / _ball.max_distance);
        var _current_speed = _ball.initial_speed * _ratio;

        // Ricochete horizontal
        if (tilemap_get_at_pixel(tilemap, _ball.x + _ball.vx + 4, _ball.y) > 0 ||
            tilemap_get_at_pixel(tilemap, _ball.x + _ball.vx - 4, _ball.y) > 0) {
            _ball.vx = -_ball.vx;
        }

        // Ricochete vertical
        if (tilemap_get_at_pixel(tilemap, _ball.x, _ball.y + _ball.vy + 4) > 0 ||
            tilemap_get_at_pixel(tilemap, _ball.x, _ball.y + _ball.vy - 4) > 0) {
            _ball.vy = -_ball.vy;
        }

        // Normaliza direcao e aplica velocidade atual
        var _dir = point_direction(0, 0, _ball.vx, _ball.vy);
        if (_ball.vx != 0 || _ball.vy != 0) {
            _ball.vx = lengthdir_x(_current_speed, _dir);
            _ball.vy = lengthdir_y(_current_speed, _dir);
        }

        // Aplica deslocamento
        _ball.x += _ball.vx;
        _ball.y += _ball.vy;
        _ball.distance_traveled += _current_speed;

        // Para ao atingir alcance maximo
        if (_ball.distance_traveled >= _ball.max_distance) {
            _ball.vx = 0;
            _ball.vy = 0;
            if (instance_exists(_ball.owner)) {
                _ball.owner.ball.on_ball_stopped(_ball.id);
            }
            return true;
        }

        return false;
    };
}
