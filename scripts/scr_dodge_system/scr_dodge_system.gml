/// @function   DodgeSystem(distance, duration_frames, cooldown_frames)
/// @description Gerencia o "se jogar no chão" do personagem.
///              Durante o dodge: movimento fixo, não pode atirar.
///              Após o dodge: cooldown antes de poder usar de novo.
///              O deslize respeita colisão com paredes via CollisionSystem.
/// @param {real} distance        Distância total percorrida no deslize (pixels)
/// @param {real} duration_frames Duração do deslize em frames (ex: 12 = 0.2s a 60fps)
/// @param {real} cooldown_frames Espera antes de poder usar de novo (ex: 30 = 0.5s)
function DodgeSystem(_distance, _duration_frames, _cooldown_frames) constructor {

    distance        = _distance;
    duration_frames = _duration_frames;
    cooldown_frames = _cooldown_frames;

    is_dodging  = false;
    on_cooldown = false;
    timer       = 0;

    _dodge_vx = 0;
    _dodge_vy = 0;

    /// @function   try_dodge(dir_x, dir_y)
    /// @description Tenta iniciar o dodge na direção informada.
    ///              Falha silenciosamente se já estiver em dodge ou cooldown.
    /// @param {real} dir_x  Direção horizontal do deslize (-1, 0 ou 1)
    /// @param {real} dir_y  Direção vertical do deslize (-1, 0 ou 1)
    /// @returns {bool}      true se o dodge foi iniciado com sucesso
    static try_dodge = function(_dx, _dy) {
        if (is_dodging || on_cooldown) return false;
        if (_dx == 0 && _dy == 0) return false;

        is_dodging = true;
        timer      = duration_frames;

        var _len = sqrt(_dx * _dx + _dy * _dy);
        var _speed_per_frame = distance / duration_frames;
        _dodge_vx = (_dx / _len) * _speed_per_frame;
        _dodge_vy = (_dy / _len) * _speed_per_frame;

        return true;
    };

    /// @function   update(x, y, collision)
    /// @description Atualiza o estado do dodge. Chame todo Step.
    ///              Recebe posição atual e CollisionSystem para checar paredes.
    ///              Para o deslize automaticamente ao bater na parede.
    /// @param {real}   px         Posição X atual do personagem
    /// @param {real}   py         Posição Y atual do personagem
    /// @param {Struct} collision  Instância do CollisionSystem
    /// @returns {Struct} struct com campos vx e vy para aplicar na posição
    static update = function(_px, _py, _collision) {
        if (is_dodging) {
            timer--;

            // Respeita colisão — para o deslize se bater na parede
            var _resolved_vx = _collision.resolve_x(_px, _py, _dodge_vx);
            var _resolved_vy = _collision.resolve_y(_px, _py, _dodge_vy);

            if (_resolved_vx == 0) _dodge_vx = 0;
            if (_resolved_vy == 0) _dodge_vy = 0;

            // Para o dodge se bater nas duas direções ou timer acabar
            if (timer <= 0 || (_dodge_vx == 0 && _dodge_vy == 0)) {
                is_dodging  = false;
                on_cooldown = true;
                timer       = cooldown_frames;
                _dodge_vx   = 0;
                _dodge_vy   = 0;
            }

            return { vx: _resolved_vx, vy: _resolved_vy };
        }

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
    /// @returns {bool} false durante o deslize e cooldown
    static can_dodge = function() {
        return !is_dodging && !on_cooldown;
    };

}