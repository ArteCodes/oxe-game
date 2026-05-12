/// @description Sistema de Menu Principal Modular com efeito de pulso
/// @param {asset.font} _font Fonte a ser usada para os textos
function MenuSystem(_font, _back) constructor {
    // --- 1. Inicialização de Variáveis --- [1, 2]
    font        = _font;
	background_sprite = _back;
    options     = ["Jogar", "Sair"]; // Opções do menu
    index       = 0;                 // Índice da opção selecionada
    pulse_timer = 0;                 // Timer para o efeito visual de pulsação

    #region Lógica de Atualização
    /// @description Processa entradas de teclado e lógica de seleção
    /// @param {id.instance} _inst ID da instância que executa o sistema
    static update = function(_inst) {
        // Incrementa o timer do pulso continuamente [Conversation History]
        pulse_timer += 0.1;

        // Navegação entre as opções (Setas Cima/Baixo)
        if (keyboard_check_pressed(vk_up)) {
            index--;
            if (index < 0) index = array_length(options) - 1;
        }
        if (keyboard_check_pressed(vk_down)) {
            index++;
            if (index >= array_length(options)) index = 0;
        }

        // Execução da opção ao pressionar Enter [3]
        if (keyboard_check_pressed(vk_enter)) {
            switch (index) {
                case 0: // Caso "Jogar"
                    room_goto_next(); // Avança para a próxima sala na lista [4]
                    break;
                case 1: // Caso "Sair"
                    game_end(); // Fecha o executável do jogo [5]
                    break;
            }
        }
    }
    #endregion

    #region Lógica de Desenho (GUI)
    /// @description Desenha os elementos do menu centralizados na camada GUI
    static draw = function() {
        // Obtém o tamanho da interface para centralização absoluta [Conversation History]
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();
		
		draw_sprite_stretched(background_sprite, 0, 0, 0, _gui_w, _gui_h);
        draw_set_font(font);
        draw_set_halign(fa_center); // Alinhamento horizontal central [6]
        draw_set_valign(fa_middle); // Alinhamento vertical central [6]

        // Loop para desenhar cada opção do array [7]
        for (var _i = 0; _i < array_length(options); _i++) {
            var _is_selected = (_i == index);
            var _color = _is_selected ? c_yellow : c_white; // Amarelo se selecionado
            
            // CÁLCULO DO EFEITO DE PULSO:
            // Usamos a função seno para oscilar suavemente entre 0.9 e 1.1 de escala [Conversation History]
            var _scale = 1;
            if (_is_selected) {
                _scale = 1 + sin(pulse_timer) * 0.1;
            }

            // Desenha o texto transformado com escala pulsante [8, 9]
            draw_text_transformed_colour(
                _gui_w / 2, 
                _gui_h / 2 + (_i * 60), 
                options[_i], 
                _scale, _scale, 0, 
                _color, _color, _color, _color, 1
            );
        }
    }
    #endregion
}