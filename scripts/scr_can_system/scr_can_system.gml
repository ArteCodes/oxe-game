/// @function   CameraSystem(view_width, view_height, follow_target)
/// @description Gerencia a camera que segue o jogador.
///              Centraliza a visao no alvo e configura a resolucao.
/// @param {real}        view_width    Largura da area visivel em pixels
/// @param {real}        view_height   Altura da area visivel em pixels
/// @param {Id.Instance} follow_target Instancia que a camera vai seguir
function CameraSystem(_width, _height, _target) constructor {

    view_w  = _width;
    view_h  = _height;
    target  = _target;

    // --- Inicializa a camera ---
    static init = function() {
        view_enabled    = true;
        view_visible[0] = true;
        camera_set_view_size(view_camera[0], view_w, view_h);

        // Resolve a resolucao com base na janela atual (ou fallback de 1280x720)
        var _w = (window_get_width() > 0) ? window_get_width() : 1280;
        var _h = (window_get_height() > 0) ? window_get_height() : 720;
        surface_resize(application_surface, _w, _h);
        view_set_wport(0, _w);
        view_set_hport(0, _h);
    };

    /// @function   update()
    /// @description Centraliza a camera no alvo. Chame todo Step.
    static update = function() {
        if (!instance_exists(target)) return;

        // Centraliza a visao no alvo
        var _cx = target.x - (view_w / 2);
        var _cy = target.y - (view_h / 2);

        camera_set_view_pos(view_camera[0], _cx, _cy);
    };

}