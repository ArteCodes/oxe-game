/// @description Sistema de Menu Principal Modular com efeito de pulso
/// @param {asset.font} _font Fonte a ser usada para os textos
function MenuSystem(_font, _back) constructor {
    // --- 1. Inicialização de Variáveis ---
    font        = _font;
    background_sprite = _back;
    options     = ["Jogar", "Configurações", "Sair"]; // Opções do menu inicial
    menu_state  = "main";            // Estados: "main", "settings"
    index       = 0;                 // Índice da opção selecionada
    pulse_timer = 0;                 // Timer para o efeito visual de pulsação

    #region Lógica de Atualização
    /// @description Processa entradas de teclado e lógica de seleção
    /// @param {id.instance} _inst ID da instância que executa o sistema
    static update = function(_inst) {
        // Incrementa o timer do pulso continuamente
        pulse_timer += 0.05;

        // Navegação entre as opções (Setas Cima/Baixo ou W/S)
        var _navigated = false;
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            index--;
            if (index < 0) index = array_length(options) - 1;
            _navigated = true;
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            index++;
            if (index >= array_length(options)) index = 0;
            _navigated = true;
        }
        if (_navigated) {
            audio_play_sound(snd_menu_button, 10, false);
        }

        // Ajustes horizontais para Volume e Mudo no submenu de configurações
        if (menu_state == "settings") {
            if (index == 0) { // Volume
                var _changed = false;
                if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
                    global.master_volume = clamp(global.master_volume - 0.05, 0.0, 1.0);
                    _changed = true;
                }
                if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
                    global.master_volume = clamp(global.master_volume + 0.05, 0.0, 1.0);
                    _changed = true;
                }
                if (_changed) {
                    audio_set_master_gain(0, global.master_mute ? 0 : global.master_volume);
                    audio_play_sound(snd_menu_button, 10, false);
                }
            }
            else if (index == 1) { // Mudo
                var _changed = false;
                if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
                    global.master_mute = !global.master_mute;
                    _changed = true;
                }
                if (_changed) {
                    audio_set_master_gain(0, global.master_mute ? 0 : global.master_volume);
                    audio_play_sound(snd_menu_button, 10, false);
                }
            }
        }

        // Execução da opção ao pressionar Enter
        if (keyboard_check_pressed(vk_enter)) {
            audio_play_sound(snd_menu_button, 10, false);
            
            if (menu_state == "main") {
                switch (index) {
                    case 0: // Jogar
                        room_goto_next(); // Avança para a próxima sala na lista (rm_main_tutorial_start)
                        break;
                    case 1: // Configurações
                        menu_state = "settings";
                        options = ["Volume", "Mudo", "Voltar"];
                        index = 0;
                        break;
                    case 2: // Sair
                        game_end(); // Fecha o executável do jogo
                        break;
                }
            } else if (menu_state == "settings") {
                switch (index) {
                    case 0: // Volume
                        // Controlado lateralmente
                        break;
                    case 1: // Mudo
                        global.master_mute = !global.master_mute;
                        audio_set_master_gain(0, global.master_mute ? 0 : global.master_volume);
                        break;
                    case 2: // Voltar
                        menu_state = "main";
                        options = ["Jogar", "Configurações", "Sair"];
                        index = 1; // Foca de volta em Configurações
                        break;
                }
            }
        }
    }
    #endregion

    #region Lógica de Desenho (GUI)
    /// @description Desenha os elementos do menu centralizados na camada GUI
    static draw = function() {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();
        
        // --- 1. Paleta de Cores Premium (Pôr do Sol & Crepúsculo) ---
        var _color_card_bg      = make_color_rgb(18, 12, 25);    // Indigo/Preto crepúsculo profundo
        var _color_gold         = make_color_rgb(255, 185, 45);   // Dourado pôr do sol vibrante (cor ativa)
        var _color_cream        = make_color_rgb(240, 230, 210);  // Creme suave de areia do deserto (cor inativa)
        var _color_highlight_bg = make_color_rgb(220, 90, 30);    // Laranja quente do pôr do sol
        
        // --- 2. Background Stretched ---
        draw_sprite_stretched(background_sprite, 0, 0, 0, _gui_w, _gui_h);
        
        // Overlay de escurecimento suave para dar destaque ao menu
        draw_set_alpha(0.35);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        draw_set_alpha(1.0);

        // --- 3. Menu Card (Efeito Glassmorphism Premium Ajustado) ---
        var _card_w = 300;
        var _card_h = 40 + (array_length(options) * 56);
        var _cx = _gui_w / 2;
        var _cy = _gui_h / 2 + 100; // Posicionado com precisão para 4 opções
        
        // Fundo do card
        draw_set_color(_color_card_bg);
        draw_set_alpha(0.85); // Opacidade refinada para melhor legibilidade
        draw_roundrect_ext(_cx - _card_w/2, _cy - _card_h/2, _cx + _card_w/2, _cy + _card_h/2, 12, 12, false);
        
        // Borda brilhante do card (com pulso sutil de opacidade)
        draw_set_color(_color_gold);
        draw_set_alpha(0.25 + sin(pulse_timer * 2.0) * 0.05);
        draw_roundrect_ext(_cx - _card_w/2, _cy - _card_h/2, _cx + _card_w/2, _cy + _card_h/2, 12, 12, true);
        draw_set_alpha(1.0);
 
        // --- 4. Desenha o Título do Jogo ---
        // Removido o draw_text de "OXE! GAME" pois o próprio background artístico já contém o logotipo desenhado profissionalmente.
 
        // --- 5. Desenha as Opções do Menu ---
        draw_set_font(font);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var _start_y = _cy - ((array_length(options) - 1) * 56) / 2;
        
        for (var _i = 0; _i < array_length(options); _i++) {
            var _is_selected = (_i == index);
            
            var _scale = 1.0;
            if (_is_selected) {
                // Escala pulsa ligeiramente para dar feedback tátil e orgânico
                _scale = 1.12 + sin(pulse_timer * 5.0) * 0.03;
            }
            
            // Dimensões do botão esticado usando Nine-Slice
            var _btn_w = 220;
            var _btn_h = 48;
            if (_is_selected) {
                _btn_w = 220 * _scale;
                _btn_h = 48 * _scale;
            }
            
            var _y_pos = _start_y + (_i * 56);
            var _bx = _cx - _btn_w / 2;
            var _by = _y_pos - _btn_h / 2;
            // Sombra do botão sutil para dar efeito de profundidade (drop shadow)
            draw_set_alpha(0.25);
            draw_set_color(c_black);
            draw_roundrect_ext(_bx - 3, _by + 3, _bx + _btn_w + 3, _by + _btn_h + 3, 12, 12, false);
            draw_set_alpha(1.0);
            
            // Corpo do botão desenhado 100% via código (sem sprites importados)
            if (_is_selected) {
                // Fundo dourado vibrante
                draw_set_color(_color_gold);
                draw_roundrect_ext(_bx, _by, _bx + _btn_w, _by + _btn_h, 12, 12, false);
                
                // Borda interna de realce levemente mais clara
                draw_set_color(c_white);
                draw_set_alpha(0.3);
                draw_roundrect_ext(_bx, _by, _bx + _btn_w, _by + _btn_h, 12, 12, true);
                draw_set_alpha(1.0);
            } else {
                // Fundo escuro translúcido estilo Glassmorphism
                draw_set_color(make_color_rgb(25, 20, 32));
                draw_set_alpha(0.65);
                draw_roundrect_ext(_bx, _by, _bx + _btn_w, _by + _btn_h, 12, 12, false);
                
                // Borda fina elegante creme suave
                draw_set_color(_color_cream);
                draw_set_alpha(0.2);
                draw_roundrect_ext(_bx, _by, _bx + _btn_w, _by + _btn_h, 12, 12, true);
                draw_set_alpha(1.0);
            }
            
            // Desenha o texto principal perfeitamente centralizado com alta legibilidade
            if (_is_selected) {
                // Texto escuro no fundo dourado
                draw_set_color(_color_card_bg);
            } else {
                // Texto creme claro no fundo escuro translúcido
                draw_set_color(_color_cream);
            }
            
            var _opt_text = options[_i];
            if (_opt_text == "Volume") {
                _opt_text = "Volume: " + string(round(global.master_volume * 100)) + "%";
            } else if (_opt_text == "Mudo") {
                _opt_text = "Mudo: " + (global.master_mute ? "Sim" : "Não");
            }
            
            draw_text_transformed(_cx, _y_pos - 1, _opt_text, _scale, _scale, 0);
            
            // Desenha indicadores simétricos pulsantes nas laterais apenas para a opção selecionada
            if (_is_selected) {
                // Distância simétrica a partir do centro do botão com animação de "respiração" horizontal
                var _indicator_offset = (_btn_w / 2) + 24 + sin(pulse_timer * 8.0) * 3;
                
                draw_set_color(_color_gold);
                // Indicador esquerdo
                draw_text_transformed(_cx - _indicator_offset, _y_pos - 2, ">", _scale, _scale, 0);
                // Indicador direito
                draw_text_transformed(_cx + _indicator_offset, _y_pos - 2, "<", _scale, _scale, 0);
            }
        }
    }
    #endregion
}