/// @function   MovementSystem(max_speed, acceleration, friction)
/// @description Gerencia o movimento top-down em 8 direcoes com aceleracao e friccao.
///              O sprite so muda nas 4 direcoes cardinais mesmo andando na diagonal.
///              Chame apply_friction() todo Step mesmo sem input.
/// @param {real} max_speed    Velocidade maxima em pixels/step
/// @param {real} acceleration Quanto de velocidade ganha por step com input
/// @param {real} friction     Fator de desaceleracao (0.0 = sem friccao, 1.0 = para na hora)
function MovementSystem(_max_speed, _acceleration, _friction) constructor {

    max_speed    = _max_speed;
    acceleration = _acceleration;
    friction     = _friction;

    vx = 0;
    vy = 0;

    // Direcao atual para o sprite — usada para trocar a animacao
    // 0 = baixo | 1 = cima | 2 = esquerda | 3 = direita
    facing = 0;

    /// @function   move(input_x, input_y)
    /// @description Aplica aceleracao com base no input do jogador.
    ///              Normaliza a diagonal para nao andar mais rapido nela.
    /// @param {real} input_x  Eixo horizontal: -1 (esq), 0 (parado), 1 (dir)
    /// @param {real} input_y  Eixo vertical:   -1 (cima), 0 (parado), 1 (baixo)
    static move = function(_ix, _iy) {
        // Normaliza diagonal (1 / sqrt(2) ≈ 0.7071)
        if (_ix != 0 && _iy != 0) {
            _ix *= 0.7071;
            _iy *= 0.7071;
        }

        vx = clamp(vx + _ix * acceleration, -max_speed, max_speed);
        vy = clamp(vy + _iy * acceleration, -max_speed, max_speed);

        // Atualiza facing pela direcao cardinal dominante
        if (abs(_ix) > abs(_iy)) {
            facing = (_ix > 0) ? 3 : 2; // direita : esquerda
        } else if (_iy != 0) {
            facing = (_iy > 0) ? 0 : 1; // baixo : cima
        }
    };

    /// @function   apply_friction()
    /// @description Desacelera o personagem gradualmente via lerp.
    ///              Deve ser chamado todo Step, com ou sem input.
    static apply_friction = function() {
        vx = lerp(vx, 0, friction);
        vy = lerp(vy, 0, friction);

        // Elimina micro-velocidade para evitar deslize infinito
        if (abs(vx) < 0.05) vx = 0;
        if (abs(vy) < 0.05) vy = 0;
    };

    /// @function   is_moving()
    /// @returns {bool} true se o personagem esta se movendo
    static is_moving = function() {
        return (vx != 0 || vy != 0);
    };

    /// @function   stop()
    /// @description Para o personagem imediatamente.
    ///              Usado no inicio do dodge e ao cancelar o carregamento.
    static stop = function() {
        vx = 0;
        vy = 0;
    };

}