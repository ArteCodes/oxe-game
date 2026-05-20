/// @function   CameraSystem(view_width, view_height, follow_target)
/// @description Gerencia a camera que segue o jogador.
///              Centraliza a visao no alvo, configura a resolucao e aceita zoom (FOV).
/// @param {real}        view_width    Largura da area visivel em pixels
/// @param {real}        view_height   Altura da area visivel em pixels
/// @param {Id.Instance} follow_target Instancia que a camera vai seguir
function CameraSystem(_width, _height, _target) constructor {

    view_w  = _width;
    view_h  = _height;
    target  = _target;
    
    // --- Configuração de FOV (Field of View / Zoom) ---
    fov        = 1.0; // Zoom / FOV ativo atual (1.0 = 100%)
    target_fov = 1.0; // FOV pretendido para transição suave

    // --- Inicializa a camera ---
    static init = function() {
        view_enabled    = true;
        view_visible[0] = true;
        camera_set_view_size(view_camera[0], view_w * fov, view_h * fov);
        window_set_fullscreen(true);

        // Resolve a resolucao da janela
        var _w = display_get_width();
        var _h = display_get_height();
        surface_resize(application_surface, _w, _h);
        view_set_wport(0, _w);
        view_set_hport(0, _h);
    };

    /// @function   update()
    /// @description Centraliza a camera no alvo aplicando o FOV dinâmico. Chame todo Step.
    static update = function() {
        if (!instance_exists(target)) return;

        // Interpolação suave em direção ao FOV desejado
        fov = lerp(fov, target_fov, 0.08);

        // Redimensiona o tamanho da visão com base na escala de FOV
        var _current_w = view_w * fov;
        var _current_h = view_h * fov;
        
        camera_set_view_size(view_camera[0], _current_w, _current_h);

        // Centraliza a visao no alvo ajustada para a dimensão atual de FOV
        var _cx = target.x - (_current_w / 2);
        var _cy = target.y - (_current_h / 2);

        camera_set_view_pos(view_camera[0], _cx, _cy);
    };

}