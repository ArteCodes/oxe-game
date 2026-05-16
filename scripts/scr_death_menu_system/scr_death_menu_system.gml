/// @description Sistema de Menu de Morte
/// @param {asset.font} _font Fonte a ser usada
function DeathMenuSystem(_font) constructor {
    font = _font;
    index = 0;
    options = ["Ressurgir", "Sair para o Menu"];

    static update = function(_inst) {
        if (keyboard_check_pressed(vk_up)) {
            index--;
            if (index < 0) index = array_length(options) - 1;
        }
        if (keyboard_check_pressed(vk_down)) {
            index++;
            if (index >= array_length(options)) index = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            switch (index) {
                case 0: // Ressurgir
                    room_restart();
                    break;
                case 1: // Sair para o Menu
                    // Aqui você pode mudar para a sala do menu principal
                    // Por enquanto vou usar game_restart() como placeholder se não houver sala definida
                    game_restart();
                    break;
            }
        }
    }

    static draw = function() {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();

        // --- 1. Overlay de fundo (Escurece a tela) ---
        draw_set_alpha(0.7);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        
        // --- 2. Opções ---
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_transformed(_gui_w/2, _gui_h/2 - 60, "VOCE MORREU!", 2, 2, 0);

        for (var _i = 0; _i < array_length(options); _i++) {
            var _color = (_i == index) ? c_yellow : c_white;
            var _prefix = (_i == index) ? "> " : "";
            
            draw_set_color(_color);
            draw_text(_gui_w/2, _gui_h/2 + (_i * 40), _prefix + options[_i]);
        }
    };
}
