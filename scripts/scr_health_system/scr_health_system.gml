/// @function   HealthSystem(max_hearts)
/// @description Gerencia os coracoes de vida do jogador.
///              Inclui i-frames e knockback ao tomar dano.
/// @param {real} max_hearts  Numero maximo de coracoes (usar 3)
function HealthSystem(_max_hearts) constructor {

    max_hearts    = _max_hearts;
    hearts        = _max_hearts;
    dead          = false;

    // --- I-frames ---
    IFRAMES_MAX   = 90;  // 1.5 segundos de invulnerabilidade
    iframes       = 0;   // contador regressivo

    // --- Knockback ---
    KNOCKBACK_FORCE    = 6;  // forca do empurrao
    KNOCKBACK_DURATION = 15; // frames do knockback
    knockback_timer    = 0;
    knockback_vx       = 0;
    knockback_vy       = 0;

    /// @function   take_damage(source_x, source_y)
    /// @description Aplica dano e knockback vindo da direcao informada.
    ///              Ignora se estiver em i-frames ou morto.
    /// @param {real} source_x  X de onde veio o dano
    /// @param {real} source_y  Y de onde veio o dano
    /// @returns {bool} true se tomou dano
    static take_damage = function(_sx, _sy, _ox, _oy) {
        if (iframes > 0 || dead) return false;

        hearts--;
        iframes = IFRAMES_MAX;

        // Knockback na direcao oposta a fonte do dano
        var _dir  = point_direction(_sx, _sy, _ox, _oy);
        knockback_vx    = lengthdir_x(KNOCKBACK_FORCE, _dir);
        knockback_vy    = lengthdir_y(KNOCKBACK_FORCE, _dir);
        knockback_timer = KNOCKBACK_DURATION;

        if (hearts <= 0) {
            hearts = 0;
            dead   = true;
        }

        return true;
    };

    /// @function   update()
    /// @description Atualiza i-frames e knockback. Chame todo Step.
    /// @returns {Struct} struct {vx, vy} com velocidade do knockback atual
    static update = function() {
        if (iframes > 0) iframes--;

        if (knockback_timer > 0) {
            knockback_timer--;
            return { vx: knockback_vx, vy: knockback_vy };
        }

        return { vx: 0, vy: 0 };
    };

    /// @function   is_invulnerable()
    /// @returns {bool} true durante os i-frames
    static is_invulnerable = function() {
        return iframes > 0;
    };

    /// @function   heal(amount)
    /// @description Cura o personagem. Nao ultrapassa max_hearts.
    /// @param {real} amount  Quantidade de coracoes a restaurar
    static heal = function(_amount) {
        hearts = min(hearts + _amount, max_hearts);
        dead   = false;
    };

}