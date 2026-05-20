/// @function DodgeSystem(distance, duration_frames, cooldown_frames)
/// @description Sistema de esquiva modular com suporte a múltiplos sistemas de colisão.
function DodgeSystem(_distance, _duration_frames, _cooldown_frames) constructor {

    #region Inicialização
    distance        = _distance;
    duration_frames = _duration_frames;
    cooldown_frames = _cooldown_frames;

    is_dodging  = false;
    on_cooldown = false;
    timer       = 0;
    _dodge_vx   = 0;
    _dodge_vy   = 0;

    // 0 = baixo | 1 = cima | 2 = esquerda | 3 = direita
    facing = 0;
    #endregion

    #region Lógica de Ativação
    static try_dodge = function(_dx, _dy) {
        if (is_dodging || on_cooldown) return false;
        if (_dx == 0 && _dy == 0) return false;

        is_dodging = true;
        timer      = duration_frames;

        var _len             = sqrt(_dx * _dx + _dy * _dy);
        var _speed_per_frame = distance / duration_frames;
        _dodge_vx = (_dx / _len) * _speed_per_frame;
        _dodge_vy = (_dy / _len) * _speed_per_frame;

        if (abs(_dx) > abs(_dy)) {
            facing = (_dx > 0) ? 3 : 2; 
        } else {
            facing = (_dy > 0) ? 0 : 1; 
        }

        return true;
    };
    #endregion

    #region Atualização de Movimento e Colisão
    /// @function update(px, py, col_full, col_half)
    /// @param {real} _px           Posição X atual do player
    /// @param {real} _py           Posição Y atual do player
    /// @param {struct} _col1       Primeiro sistema de colisão (ex: collision_cheia)
    /// @param {struct} _col2       Segundo sistema de colisão (ex: collision_meia)
    static update = function(_px, _py, _col1, _col2) {
        if (is_dodging) {
            timer--;

            // RESOLUÇÃO SEQUENCIAL: Passa o movimento por ambos os sistemas [Conversation History]
            // Primeiro checa contra o sistema 1
            var _resolved_vx = _col1.resolve_x(_px, _py, _dodge_vx);
            // O resultado do sistema 1 é testado contra o sistema 2
            _resolved_vx = _col2.resolve_x(_px, _py, _resolved_vx);

            // Repete o processo para o eixo Y
            var _resolved_vy = _col1.resolve_y(_px, _py, _dodge_vy);
            _resolved_vy = _col2.resolve_y(_px, _py, _resolved_vy);

            // Se bater em qualquer parede, zera a velocidade interna para cancelar o deslize naquela direção
            if (_resolved_vx == 0) _dodge_vx = 0;
            if (_resolved_vy == 0) _dodge_vy = 0;

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
    #endregion

    #region Verificadores de Estado
    static can_act = function() {
        return !is_dodging;
    };

    static can_dodge = function() {
        return !is_dodging && !on_cooldown;
    };
    #endregion
}