/// @function   BallSystem()
/// @description Gerencia o estado da bolinha do jogador.
///              Estados: IDLE (tem bola), FIRED (voando), FLOOR (parada no chao).
function BallSystem() constructor {

    // --- Estados possiveis ---
    IDLE  = 0; // tem bolinha, pode disparar
    FIRED = 1; // bolinha voando
    FLOOR = 2; // bolinha parada no chao esperando coleta

    state    = IDLE;
    ball_ref = noone; // referencia ao obj_ball ativo
	
	// --- Recarga da bolsa ---
	RELOAD_TIME   = 120; // 2 segundos a 60fps
	is_reloading  = false;
	reload_timer  = 0;

    /// @function   try_fire(ox, oy, tx, ty, layer, owner, speed, distance)
    /// @description Cria a bolinha e a dispara na direcao do alvo.
    ///              So funciona no estado IDLE.
    /// @param {real}        ox        X do jogador
    /// @param {real}        oy        Y do jogador
    /// @param {real}        tx        X do alvo (mouse)
    /// @param {real}        ty        Y do alvo (mouse)
    /// @param {string}      layer     Nome da layer de instancias
    /// @param {Id.Instance} owner     Referencia ao obj_player
    /// @param {real}        speed     Velocidade inicial (vem do SlingshotSystem)
    /// @param {real}        distance  Alcance total (vem do SlingshotSystem)
    /// @returns {bool} true se disparou com sucesso
    static try_fire = function(_ox, _oy, _tx, _ty, _layer, _owner, _speed, _distance) {
        if (state != IDLE) return false;

        // Cria a bolinha de forma robusta e defensiva à prova de falhas
        var _target_layer = -1;
        
        // 1. Verifica se a camada passada por argumento é válida e existe (deve ser string e existir, ou ser ID válido)
        if (is_string(_layer) && layer_exists(_layer)) {
            _target_layer = layer_get_id(_layer);
        } else if (layer_exists(_layer)) {
            _target_layer = _layer;
        }
        
        // 2. Fallback para "Instances" se a camada anterior for inválida
        if (_target_layer == -1 && layer_exists("Instances")) {
            _target_layer = layer_get_id("Instances");
        }
        
        // 3. Fallback para a camada do jogador se for válida (diferente de -1)
        if (_target_layer == -1 && _owner.layer != -1 && layer_exists(_owner.layer)) {
            _target_layer = _owner.layer;
        }
        
        // 4. Criação da instância de forma segura
        if (_target_layer != -1) {
            ball_ref = instance_create_layer(_ox, _oy, _target_layer, obj_ball);
        } else {
            // Fallback absoluto: cria usando profundidade do player para evitar crashes se nenhuma camada funcionar
            ball_ref = instance_create_depth(_ox, _oy, _owner.depth, obj_ball);
        }
        ball_ref.owner         = _owner;
        ball_ref.initial_speed = _speed;
        ball_ref.max_distance  = _distance;

        // Aplica velocidade na direcao do alvo
        var _dir   = point_direction(_ox, _oy, _tx, _ty);
        ball_ref.vx = lengthdir_x(_speed, _dir);
        ball_ref.vy = lengthdir_y(_speed, _dir);

        state = FIRED;
        return true;
    };

    /// @function   on_ball_stopped(ball)
    /// @description Chamado pelo obj_ball quando para no chao.
    ///              Transita para FLOOR — bolinha coletavel.
    /// @param {Id.Instance} ball  Referencia ao obj_ball que parou
    static on_ball_stopped = function(_ball) {
        ball_ref = _ball;
        state    = FLOOR;
    };

    /// @function   on_ball_collected()
    /// @description Chamado ao coletar a bolinha.
    ///              Destroi o obj_ball e volta para IDLE.
    static on_ball_collected = function() {
        if (instance_exists(ball_ref)) instance_destroy(ball_ref);
        ball_ref = noone;
        state    = IDLE;
    };

    /// @function   try_reload()
    /// @description Descarta a bolinha atual e volta para IDLE.
    ///              Usado ao buscar nova bolinha da bolsa (bolinha anterior some).
    static try_reload = function() {
        if (state == IDLE) return;
        if (instance_exists(ball_ref)) instance_destroy(ball_ref);
        ball_ref = noone;
        state    = IDLE;
    };

    /// @function   can_fire()
    /// @returns {bool} true apenas no estado IDLE
    static can_fire = function() {
        return state == IDLE;
    };
	/// @function   update_reload(holding_r)
	/// @description Chame todo Step passando se R esta sendo segurado.
	///              Ao completar destroi a bolinha atual e volta para IDLE.
	/// @param {bool} holding_r  true enquanto tecla R estiver pressionada
	/// @returns {bool} true se acabou de completar a recarga
	static update_reload = function(_holding) {
	    // So pode recarregar se tiver bolinha ativa ou no chao
	    if (state == IDLE) {
	        is_reloading = false;
	        reload_timer = 0;
	        return false;
	    }

	    if (_holding) {
	        is_reloading = true;
	        reload_timer = min(reload_timer + 1, RELOAD_TIME);

	        // Completou a recarga
	        if (reload_timer >= RELOAD_TIME) {
	            try_reload();
	            is_reloading = false;
	            reload_timer = 0;
	            return true;
	        }
	    } else {
	        // Soltou antes de completar — cancela
	        is_reloading = false;
	        reload_timer = 0;
	    }

	    return false;
	};

	/// @function   get_reload_ratio()
	/// @description Retorna o progresso da recarga entre 0.0 e 1.0.
	/// @returns {real}
	static get_reload_ratio = function() {
	    return reload_timer / RELOAD_TIME;
	};
}