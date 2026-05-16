pause_sys = new PauseMenuSystem(-1); // Usando -1 para fonte padrão se fnt_menu não existir
screen_sprite = -1;

// Captura a tela atual para mostrar no fundo do pause com segurança
if (surface_exists(application_surface)) {
    var _w = surface_get_width(application_surface);
    var _h = surface_get_height(application_surface);
    
    // Só tenta criar o sprite se as dimensões forem válidas (evita erro de GPU ao minimizar)
    if (_w > 0 && _h > 0) {
        try {
            screen_sprite = sprite_create_from_surface(application_surface, 0, 0, _w, _h, false, false, 0, 0);
        } catch (_ex) {
            screen_sprite = -1;
            show_debug_message("Erro ao capturar superfície: " + string(_ex));
        }
    }
}

instance_deactivate_all(true);