/// @function   SlingshotSystem(ball_system)
/// @description Veiculo entre o jogador e a bolinha.
///              Gerencia carregamento, velocidade e alcance do disparo.
///              Apos 4 segundos sem soltar cancela e aplica cooldown do dodge.
/// @param {Struct} ball_system  Instancia do BallSystem do jogador
function SlingshotSystem(_ball) constructor {

    ball      = _ball;
    owner_ref = noone; // definido no Create do obj_player: slingshot.owner_ref = id

    // --- Configuracoes de tempo ---
    CHARGE_MAX       = 120; // 2s a 60fps — barra cheia
    CHARGE_THRESHOLD = 60;  // 1s a 60fps — minimo para tiro carregado
    CHARGE_TIMEOUT   = 240; // 4s a 60fps — estouro forcado

    // --- Configuracoes de tiro ---
    SPEED_QUICK   = 6;   // velocidade do tiro rapido
    SPEED_CHARGED = 10;  // velocidade do tiro carregado
    DIST_QUICK    = 200; // alcance do tiro rapido em pixels
    DIST_CHARGED  = 400; // alcance do tiro carregado em pixels

    // --- Estado ---
    is_charging   = false;
    charge_time   = 0;
    needs_repress = false; // true apos estouro — forca soltar e apertar de novo

    /// @function   update(shooting, can_shoot)
    /// @description Chame todo Step passando o estado do botao direito.
    /// @param {bool} shooting   true enquanto botao direito estiver pressionado
    /// @param {bool} can_shoot  false durante dodge ou com bolinha ativa
    static update = function(_shooting, _can_shoot) {

        // Inicia carregamento ao apertar o botao
        if (_shooting && _can_shoot && !is_charging && !needs_repress) {
            is_charging = true;
            charge_time = 0;
        }

        if (is_charging) {
            if (_shooting) {
                charge_time = min(charge_time + 1, CHARGE_TIMEOUT);

                // Estouro — cancela, bloqueia e aplica cooldown do dodge
                if (charge_time >= CHARGE_TIMEOUT) {
                    cancel();
                    needs_repress = true;
                    if (instance_exists(owner_ref)) {
                        owner_ref.dodge.on_cooldown = true;
                        owner_ref.dodge.timer = owner_ref.dodge.cooldown_frames;
                    }
                }
            } else {
                // Soltou o botao — dispara
                _fire();
            }
        }

        // Libera o bloqueio quando o jogador soltar o botao
        if (needs_repress && !_shooting) {
            needs_repress = false;
        }
    };

    /// @function   _fire()
    /// @description Dispara a bolinha com velocidade e alcance do charge_time atual.
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
    /// @description Retorna speed e distance com base no charge_time atual.
    ///              Tiro rapido se < CHARGE_THRESHOLD, carregado se >= CHARGE_THRESHOLD.
    /// @returns {Struct}  struct com campos speed e distance
    static get_shot_data = function() {
        if (charge_time >= CHARGE_THRESHOLD) {
            return { speed: SPEED_CHARGED, distance: DIST_CHARGED };
        }
        return { speed: SPEED_QUICK, distance: DIST_QUICK };
    };

    /// @function   get_charge_ratio()
    /// @description Retorna o progresso do carregamento entre 0.0 e 1.0.
    ///              Usado pela barra visual no Draw do obj_player.
    /// @returns {real}
    static get_charge_ratio = function() {
        return charge_time / CHARGE_MAX;
    };

    /// @function   cancel()
    /// @description Cancela o carregamento sem disparar.
    ///              Chamado pelo dodge e pelo estouro de tempo.
    static cancel = function() {
        is_charging = false;
        charge_time = 0;
    };

}