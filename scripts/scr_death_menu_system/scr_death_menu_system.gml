/// @description Sistema de Menu de Morte Modular com efeitos visuais e preservação de configurações
/// @param {asset.font} _font Fonte a ser usada
function DeathMenuSystem(_font) constructor {
    font = _font;
    index = 0;
    options = ["Ressurgir", "Voltar ao Menu"];
    pulse_timer = 0;

    static update = function(_inst) {
        pulse_timer += 0.05;

        // Navegação (Setas ou W/S)
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            index--;
            if (index < 0) index = array_length(options) - 1;
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            index++;
            if (index >= array_length(options)) index = 0;
        }

        // Execução
        if (keyboard_check_pressed(vk_enter)) {
            // Para a música de morte antes de mudar de tela
            audio_stop_sound(snd_death);
            
            switch (index) {
                case 0: // Ressurgir
                    room_restart();
                    break;
                case 1: // Voltar ao Menu Principal (Usa room_goto para preservar tamanho de janela e configurações)
                    if (room_exists(rm_main_menu)) {
                        room_goto(rm_main_menu);
                    } else {
                        game_restart();
                    }
                    break;
            }
        }
    }

    static draw = function() {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();

        // --- 1. Overlay de Fundo (Escurece a tela de jogo) ---
        draw_set_alpha(0.75);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        draw_set_alpha(1.0);
        
        // --- 2. Glassmorphism Death Card ---
        var _cx = _gui_w / 2;
        var _cy = _gui_h / 2 + 30;
        var _card_w = 420;
        var _card_h = 240;
        
        // Fundo do card
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_roundrect_ext(_cx - _card_w/2, _cy - _card_h/2, _cx + _card_w/2, _cy + _card_h/2, 20, 20, false);
        
        // Borda vermelha piscante
        draw_set_color(c_red);
        draw_set_alpha(0.3 + sin(pulse_timer * 2.0) * 0.1);
        draw_roundrect_ext(_cx - _card_w/2, _cy - _card_h/2, _cx + _card_w/2, _cy + _card_h/2, 20, 20, true);
        draw_set_alpha(1.0);
        
        // --- 3. Desenha o Título (VOCÊ MORREU!) ---
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(font);
        
        var _title_scale = 2.2 + sin(pulse_timer * 1.5) * 0.05;
        
        // Sombra
        draw_set_color(c_black);
        draw_text_transformed(_cx + 4, _cy - 166, "VOCÊ MORREU!", _title_scale, _title_scale, 0);
        
        // Texto em vermelho pulsante de perigo
        draw_set_color(c_red);
        draw_text_transformed(_cx, _cy - 170, "VOCÊ MORREU!", _title_scale, _title_scale, 0);

        // --- 4. Desenha as Opções ---
        for (var _i = 0; _i < array_length(options); _i++) {
            var _is_selected = (_i == index);
            var _color = _is_selected ? c_yellow : c_white;
            var _prefix = _is_selected ? "▶ " : "";
            var _scale = _is_selected ? 1.2 : 1.0;
            
            if (_is_selected) {
                // Fundo de destaque
                draw_set_color(c_yellow);
                draw_set_alpha(0.12);
                draw_roundrect_ext(_cx - 150, _cy - 40 + (_i * 60) - 18, _cx + 150, _cy - 40 + (_i * 60) + 18, 10, 10, false);
                draw_set_alpha(1.0);
            }
            
            draw_set_color(_color);
            draw_text_transformed(_cx, _cy - 40 + (_i * 60), _prefix + options[_i], _scale, _scale, 0);
        }
    };
}
