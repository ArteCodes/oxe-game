/// @description Sistema de Menu de Pausa Modular
/// @param {asset.font} _font Fonte a ser usada
function PauseMenuSystem(_font) constructor {
    font = _font;
    state = "main"; 
    index = 0;
    
    main_options = ["Retomar", "Ressurgir", "Sair"];
    confirm_options = ["Confirmar Sair?", "Sim", "Nao"];

    static update = function(_inst) {
        var _current_options = (state == "main") ? main_options : confirm_options;
        var _len = array_length(_current_options);
        var _min_idx = (state == "main") ? 0 : 1;

        if (keyboard_check_pressed(vk_up)) {
            index--;
            if (index < _min_idx) index = _len - 1;
        }
        if (keyboard_check_pressed(vk_down)) {
            index++;
            if (index >= _len) index = _min_idx;
        }

        if (keyboard_check_pressed(vk_enter)) {
            if (state == "main") {
                switch (index) {
                    case 0: instance_destroy(_inst); break;
                    case 1: room_restart(); break;
                    case 2: state = "confirm"; index = 1; break;
                }
            } 
            else if (state == "confirm") {
                if (index == 1) game_end(); 
                else { state = "main"; index = 2; }
            }
        }
    }

    /// @description Desenha o menu na camada GUI
    static draw = function() {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();

        draw_set_font(font);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Fundo escurecido ocupando a tela toda (GUI)
        draw_set_alpha(0.6);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        draw_set_alpha(1);
        draw_set_color(c_white);

        var _opts = (state == "main") ? main_options : confirm_options;
        for (var _i = 0; _i < array_length(_opts); _i++) {
            var _color = (_i == index) ? c_yellow : c_white;
            draw_text_transformed_colour(_gui_w / 2, (_gui_h / 2 - 40) + (_i * 40), _opts[_i], 1, 1, 0, _color, _color, _color, _color, 1);
        }
    };
}