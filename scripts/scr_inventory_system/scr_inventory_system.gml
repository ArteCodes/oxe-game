/// @function   InventorySystem(max_stones)
/// @description Gerencia o estoque de pedras extras do jogador.
///              Pedras sao coletadas automaticamente ao passar por cima quando
///              o estilingue ja esta carregado. Para usar uma pedra do estoque,
///              o jogador fica parado e vulneravel durante o tempo de recarga.
///              Chame update() todo Step para contar o tempo de recarga.
/// @param {real} max_stones  Capacidade maxima do estoque (usar 3)
function InventorySystem(_max_stones) constructor {

    max_stones = _max_stones;
    count      = 0;       // pedras atualmente no estoque

    // --- Recarga ao usar pedra do estoque ---
    RELOAD_TIME  = 240;   // 4 segundos a 60fps — jogador fica vulneravel
    is_reloading = false;
    reload_timer = 0;

    /// @function   can_store()
    /// @description Verifica se ha espaco no estoque para mais uma pedra.
    /// @returns {bool} true se count < max_stones
    static can_store = function() {
        return count < max_stones;
    };

    /// @function   add()
    /// @description Adiciona uma pedra ao estoque.
    ///              Chamar apenas apos verificar can_store().
    /// @returns {bool} true se adicionou com sucesso
    static add = function() {
        if (count >= max_stones) return false;
        count++;
        return true;
    };

    /// @function   try_use()
    /// @description Tenta usar uma pedra do estoque, iniciando o tempo de recarga.
    ///              Falha se o estoque estiver vazio ou ja estiver em recarga.
    ///              Durante a recarga o jogador deve ficar parado e vulneravel
    ///              --- responsabilidade do obj_player checar is_reloading no Step.
    /// @returns {bool} true se iniciou o uso com sucesso
    static try_use = function() {
        if (count <= 0) return false;
        if (is_reloading) return false;
        count--;
        is_reloading = true;
        reload_timer = RELOAD_TIME;
        return true;
    };

    /// @function   update()
    /// @description Conta regressivamente o tempo de recarga. Chame todo Step.
    /// @returns {bool} true no frame exato em que a recarga terminou
    static update = function() {
        if (!is_reloading) return false;
        reload_timer--;
        if (reload_timer <= 0) {
            is_reloading = false;
            reload_timer = 0;
            return true; // sinaliza que o BallSystem pode voltar para IDLE
        }
        return false;
    };

    /// @function   get_reload_ratio()
    /// @description Retorna o progresso da recarga entre 0.0 e 1.0.
    ///              Usado pelo obj_hud para desenhar o indicador visual.
    /// @returns {real}
    static get_reload_ratio = function() {
        if (!is_reloading) return 0;
        return 1 - (reload_timer / RELOAD_TIME);
    };

    /// @function   is_empty()
    /// @description Verifica se o estoque esta vazio.
    /// @returns {bool}
    static is_empty = function() {
        return count <= 0;
    };
}
