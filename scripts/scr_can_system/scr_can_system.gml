/// @function   CameraSystem(view_width, view_height, follow_target)
/// @description Gerencia a camera que segue o jogador com resolucao dinamica.
///              Chame init() no Create Event e update() todo Step.
///              So existe uma camera ativa (view[0]) — comportamento intencional.
/// @param {real}        view_width    Largura da area visivel em pixels (resolucao do jogo)
/// @param {real}        view_height   Altura da area visivel em pixels (resolucao do jogo)
/// @param {Id.Instance} follow_target Instancia que a camera vai seguir (normalmente obj_player)
function CameraSystem(_width, _height, _target) constructor {

    view_w = _width;
    view_h = _height;
    target = _target;

    /// @function   init()
    /// @description Ativa a view, configura fullscreen e ajusta a resolucao da janela.
    ///              Deve ser chamado uma unica vez no Create Event do obj_player ou obj_manager.
    ///              Afeta view[0] globalmente — nao chamar mais de uma vez por cena.
    static init = function() {
        view_enabled    = true;
        view_visible[0] = true;

        camera_set_view_size(view_camera[0], view_w, view_h);
        window_set_fullscreen(true);

        // Ajusta a resolucao do application_surface ao tamanho real da janela
        var _w = display_get_width();
        var _h = display_get_height();
        surface_resize(application_surface, _w, _h);
        view_set_wport(0, _w);
        view_set_hport(0, _h);
    };

    /// @function   update()
    /// @description Centraliza a camera no alvo. Chame todo Step.
    ///              Nao faz nada se o alvo foi destruido.
    static update = function() {
        if (!instance_exists(target)) return;

        var _cx = target.x - (view_w / 2);
        var _cy = target.y - (view_h / 2);
        camera_set_view_pos(view_camera[0], _cx, _cy);
    };
}
