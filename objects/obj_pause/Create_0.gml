pause_sys = new PauseMenuSystem(-1); // Usando -1 para fonte padrão se fnt_menu não existir
screen_sprite = -1;

// Captura a tela atual para mostrar no fundo do pause
if (surface_exists(application_surface)) {
    var _w = surface_get_width(application_surface);
    var _h = surface_get_height(application_surface);
    screen_sprite = sprite_create_from_surface(application_surface, 0, 0, _w, _h, false, false, 0, 0);
}

instance_deactivate_all(true);