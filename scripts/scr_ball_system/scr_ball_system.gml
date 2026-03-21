/// @function   BallSystem()
/// @description Gerencia o estado da bolinha do jogador.
///              Estados: IDLE (tem bola), FIRED (bola ativa), FLOOR (bola no chao).
function BallSystem() constructor {

    // Estados possíveis
    IDLE  = 0; // tem bolinha, pode disparar
    FIRED = 1; // bolinha voando
    FLOOR = 2; // bolinha parada no chão esperando coleta

    state      = IDLE;
    ball_ref   = noone; // referência ao obj_ball ativo

    /// @function   try_fire(owner_x, owner_y, target_x, target_y, layer_name)
    /// @description Tenta disparar a bolinha. Só funciona no estado IDLE.
    /// @param {real}   owner_x     X do jogador
    /// @param {real}   owner_y     Y do jogador
    /// @param {real}   target_x    X do alvo (mouse)
    /// @param {real}   target_y    Y do alvo (mouse)
    /// @param {string} layer_name  Nome da layer de instâncias
    /// @returns {bool} true se disparou
	static try_fire = function(_ox, _oy, _tx, _ty, _layer, _owner) {
	    if (state != IDLE) return false;

	    ball_ref = instance_create_layer(_ox, _oy, _layer, obj_ball);
	    ball_ref.owner = _owner; // recebe o owner como parâmetro
	    var _dir = point_direction(_ox, _oy, _tx, _ty);
	    ball_ref.vx = lengthdir_x(8, _dir);
	    ball_ref.vy = lengthdir_y(8, _dir);

	    state = FIRED;
	    return true;
	};

    /// @function   on_ball_stopped(ball)
    /// @description Chamado pelo obj_ball quando para no chão.
    /// @param {Id.Instance} ball  Referência ao obj_ball que parou
    static on_ball_stopped = function(_ball) {
        ball_ref = _ball;
        state    = FLOOR;
    };

    /// @function   on_ball_collected()
    /// @description Chamado quando o jogador coleta a bolinha.
    static on_ball_collected = function() {
        if (instance_exists(ball_ref)) instance_destroy(ball_ref);
        ball_ref = noone;
        state    = IDLE;
    };

    /// @function   try_reload()
    /// @description Descarta a bolinha atual e volta para IDLE.
    ///              Usada quando o jogador busca nova bolinha da bolsa.
    static try_reload = function() {
        if (state == IDLE) return;
        if (instance_exists(ball_ref)) instance_destroy(ball_ref);
        ball_ref = noone;
        state    = IDLE;
    };

    /// @function   can_fire()
    /// @returns {bool} true se pode disparar agora
    static can_fire = function() {
        return state == IDLE;
    };

}