/// @function   SlingshotSystem(ball_system)
/// @description Veiculo entre o jogador e a bolinha.
///              Gerencia carregamento, velocidade e alcance do disparo.
///              Cancelamento automatico apos 8 segundos aplica cooldown do dodge.
/// @param {Struct} ball_system  Instancia do BallSystem do jogador
function SlingshotSystem(_ball) constructor {

    ball      = _ball;
    owner_ref = noone;

    // Configuracoes de tiro
    CHARGE_MAX       = 120; // 2 segundos a 60fps
    CHARGE_THRESHOLD = 60;  // 1 segundo = tiro carregado
    CHARGE_TIMEOUT   = 240; // 4 segundos = cancela com cooldown
	

    SPEED_QUICK   = 6;
    SPEED_CHARGED = 10;
    DIST_QUICK    = 200;
    DIST_CHARGED  = 400;

    // Estado
    is_charging = false;
    charge_time = 0;
	needs_repress = false; 

    /// @function   update(shooting, can_shoot)
    /// @description Chame todo Step passando se o botao esta pressionado.
    /// @param {bool} shooting   true enquanto botao direito estiver pressionado
    /// @param {bool} can_shoot  false durante dodge ou com bolinha ativa
    static update = function(_shooting, _can_shoot) {
        if (_shooting && _can_shoot && !is_charging && !needs_repress) {
		    is_charging = true;
		    charge_time = 0;
		}

		if (is_charging) {
		    if (_shooting) {
		        charge_time = min(charge_time + 1, CHARGE_TIMEOUT);

		        if (charge_time >= CHARGE_TIMEOUT) {
		            cancel();
		            needs_repress = true; // bloqueia até soltar o botão
		            if (instance_exists(owner_ref)) {
		                owner_ref.dodge.on_cooldown = true;
		                owner_ref.dodge.timer = owner_ref.dodge.cooldown_frames;
		            }
		        }
		    } else {
		        _fire();
		    }
		}

		// Reseta o bloqueio quando o jogador soltar o botão
		if (needs_repress && !_shooting) {
		    needs_repress = false;
}
    };

    /// @function   _fire()
    /// @description Dispara a bolinha com os parametros calculados.
    static _fire = function() {
        if (!instance_exists(owner_ref)) return;
        var _data = get_shot_data();
        ball.try_fire(
            owner_ref.x, owner_ref.y,
            mouse_x, mouse_y,
            "Instances",
            owner_ref.id,
            _data.speed,
            _data.distance
        );
        is_charging = false;
        charge_time = 0;
    };

    /// @function   get_shot_data()
    /// @description Retorna speed e distance baseados no charge_time atual.
    /// @returns {Struct}  struct com campos speed e distance
    static get_shot_data = function() {
        if (charge_time >= CHARGE_THRESHOLD) {
            return { speed: SPEED_CHARGED, distance: DIST_CHARGED };
        }
        return { speed: SPEED_QUICK, distance: DIST_QUICK };
    };

    /// @function   get_charge_ratio()
    /// @description Retorna progresso do carregamento entre 0.0 e 1.0.
    /// @returns {real}
    static get_charge_ratio = function() {
        return charge_time / CHARGE_MAX;
    };

    /// @function   cancel()
    /// @description Cancela o carregamento sem disparar.
    static cancel = function() {
        is_charging = false;
        charge_time = 0;
    };

}