/// @function   DodgeSystem(distance, duration_frames, cooldown_frames)
/// @description Gerencia o "se jogar no chao" do personagem.
///              Durante o dodge: movimento fixo, nao pode atirar.
///              Apos o dodge: cooldown antes de poder usar de novo.
///              O deslize respeita colisao com paredes via CollisionSystem.
/// @param {real} distance        Distancia total percorrida no deslize (pixels)
/// @param {real} duration_frames Duracao do deslize em frames (ex: 20 = 0.3s a 60fps)
/// @param {real} cooldown_frames Espera antes de poder usar de novo (ex: 36 = 0.6s)
function DodgeSystem(_distance, _duration_frames, _cooldown_frames) constructor {

    distance        = _distance;
    duration_frames = _duration_frames;
    cooldown_frames = _cooldown_frames;

    // --- Estado interno ---
    is_dodging  = false;
    on_cooldown = false;
    timer       = 0;
    _dodge_vx   = 0;
    _dodge_vy   = 0;

    /// @function   try_dodge(dir_x, dir_y)
    /// @description Tenta iniciar o deslize na direcao do input.
    ///              Falha silenciosamente se em dodge, cooldown ou sem direcao.
    /// @param {real} dir_x  Direcao horizontal (-1, 0 ou 1)
    /// @param {real} dir_y  Direcao vertical   (-1, 0 ou 1)
    /// @returns {bool}      true se o dodge foi iniciado
    static try_dodge = function(_dx, _dy) {
        if (is_dodging || on_cooldown) return false;
        if (_dx == 0 && _dy == 0) return false;

        is_dodging = true;
        timer      = duration_frames;

        // Normaliza diagonal e calcula velocidade por frame
        var _len          = sqrt(_dx * _dx + _dy * _dy);
        var _speed_per_frame = distance / duration_frames;
        _dodge_vx = (_dx / _len) * _speed_per_frame;
        _dodge_vy = (_dy / _len) * _speed_per_frame;

        return true;
    };

    /// @function   update(px, py, collision)
    /// @description Atualiza o estado do dodge. Chame todo Step.
    ///              Para automaticamente ao bater na parede.
    /// @param {real}   px         Posicao X atual do personagem
    /// @param {real}   py         Posicao Y atual do personagem
    /// @param {Struct} collision  Instancia do CollisionSystem
    /// @returns {Struct} struct {vx, vy} com a velocidade do deslize atual
    static update = function(_px, _py, _collision) {
        if (is_dodging) {
            timer--;

            // Checa colisao — zera a direcao que bateu na parede
            var _resolved_vx = _collision.resolve_x(_px, _py, _dodge_vx);
            var _resolved_vy = _collision.resolve_y(_px, _py, _dodge_vy);
            if (_resolved_vx == 0) _dodge_vx = 0;
            if (_resolved_vy == 0) _dodge_vy = 0;

            // Encerra o dodge se o timer acabar ou bater nas duas direcoes
            if (timer <= 0 || (_dodge_vx == 0 && _dodge_vy == 0)) {
                is_dodging  = false;
                on_cooldown = true;
                timer       = cooldown_frames;
                _dodge_vx   = 0;
                _dodge_vy   = 0;
            }

            return { vx: _resolved_vx, vy: _resolved_vy };
        }

        // Conta o cooldown apos o deslize
        if (on_cooldown) {
            timer--;
            if (timer <= 0) on_cooldown = false;
        }

        return { vx: 0, vy: 0 };
    };

    /// @function   can_act()
    /// @returns {bool} false durante o deslize — bloqueia atirar a bolinha
    static can_act = function() {
        return !is_dodging;
    };

    /// @function   can_dodge()
    /// @returns {bool} false durante o deslize e o cooldown
    static can_dodge = function() {
        return !is_dodging && !on_cooldown;
    };

}