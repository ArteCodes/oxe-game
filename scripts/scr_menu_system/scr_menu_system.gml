/// @description Sistema de Menu Modular
/// @param {asset} _font Fonte a ser usada
function MenuSystem(_font) constructor {
    font = _font;
    options = ["Jogar", "Sair"]; // Array com as opções [6]
    index = 0; // Qual opção está selecionada no momento
    
    // Método para atualizar a lógica (teclado/mouse)
    static update = function(_inst) {
        // Navegação com as setas do teclado [7]
        if (keyboard_check_pressed(vk_up)) {
            index--;
            if (index < 0) index = array_length(options) - 1;
        }
        if (keyboard_check_pressed(vk_down)) {
            index++;
            if (index >= array_length(options)) index = 0;
        }

        // Selecionar a opção ao apertar Enter [8]
        if (keyboard_check_pressed(vk_enter)) {
            switch (index) {
                case 0: // Caso "Jogar"
                    room_goto_next(); // Vai para a primeira fase [9]
                    break;
                case 1: // Caso "Sair"
                    game_end(); // Fecha o jogo [10]
                    break;
            }
        }
    }

    // Método para desenhar o menu na tela [11]
    static draw = function(_inst) {
        draw_set_font(font); [12]
        draw_set_halign(fa_center); // Centraliza horizontalmente [13, 14]
        draw_set_valign(fa_middle); // Centraliza verticalmente [13, 14]

        for (var _i = 0; _i < array_length(options); _i++) {
            var _color = (_i == index) ? c_yellow : c_white; // Destaca a opção selecionada
            draw_text_transformed_colour(room_width / 2, room_height / 2 + (_i * 40), options[_i], 1, 1, 0, _color, _color, _color, _color, 1); [15]
        }
    }
}