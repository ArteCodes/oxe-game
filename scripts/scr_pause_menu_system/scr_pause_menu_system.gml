/// @description Sistema de Menu de Pausa Modular Premium com suporte a Menu Principal
/// @param {asset.font} _font Fonte a ser usada
function PauseMenuSystem(_font) constructor {
    font = _font;
    state = "main"; 
    index = 0;
    pulse_timer = 0;
    
    main_options = ["Retomar", "Volume", "Mudo", "Ressurgir", "Voltar ao Menu", "Sair do Jogo"];
    confirm_options = ["Confirmar Sair?", "Sim", "Não"];

    static update = function(_inst) {
        pulse_timer += 0.05;
        var _current_options = (state == "main") ? main_options : confirm_options;
        var _len = array_length(_current_options);
        var _min_idx = (state == "main") ? 0 : 1;

        // Navegação (Setas ou W/S)
        var _navigated = false;
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            index--;
            if (index < _min_idx) index = _len - 1;
            _navigated = true;
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            index++;
            if (index >= _len) index = _min_idx;
            _navigated = true;
        }
        if (_navigated) {
            audio_play_sound(snd_menu_button, 10, false);
        }

        // Ajustes horizontais para Volume e Mudo no pause
        if (state == "main") {
            if (index == 1) { // Volume
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
            else if (index == 2) { // Mudo
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

        // Execução
        if (keyboard_check_pressed(vk_enter)) {
            audio_play_sound(snd_menu_button, 10, false);
            if (state == "main") {
                switch (index) {
                    case 0: // Retomar
                        instance_destroy(_inst); 
                        break;
                    case 1: // Volume
                        // Controlado por setas laterais
                        break;
                    case 2: // Mudo
                        global.master_mute = !global.master_mute;
                        audio_set_master_gain(0, global.master_mute ? 0 : global.master_volume);
                        break;
                    case 3: // Ressurgir (Reiniciar sala)
                        room_restart(); 
                        break;
                    case 4: // Voltar ao Menu Principal
                        if (room_exists(rm_main_menu)) {
                            room_goto(rm_main_menu);
                        } else {
                            game_restart();
                        }
                        break;
                    case 5: // Sair do jogo
                        state = "confirm"; 
                        index = 1; 
                        break;
                }
            } 
            else if (state == "confirm") {
                if (index == 1) {
                    game_end(); // Sim -> Fecha jogo
                } else { 
                    state = "main"; 
                    index = 5; // Não -> Volta ao menu de pausa no item Sair
                }
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
        
        // Fundo escurecido suave por trás
        draw_set_alpha(0.65);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        draw_set_alpha(1.0);

        // --- 2. Glassmorphism Pause Card ---
        var _cx = _gui_w / 2;
        var _cy = _gui_h / 2;
        var _card_w = 420;
        var _card_h = (state == "main") ? 80 + (array_length(main_options) * 55) : 200;
        
        // Fundo do card de pausa
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_roundrect_ext(_cx - _card_w/2, _cy - _card_h/2, _cx + _card_w/2, _cy + _card_h/2, 20, 20, false);
        
        // Borda brilhante amarela do card
        draw_set_color(c_yellow);
        draw_set_alpha(0.3);
        draw_roundrect_ext(_cx - _card_w/2, _cy - _card_h/2, _cx + _card_w/2, _cy + _card_h/2, 20, 20, true);
        draw_set_alpha(1.0);

        // --- 3. Título do Card ---
        if (state == "main") {
            draw_set_color(c_black);
            draw_text_transformed(_cx + 3, _cy - _card_h/2 + 40 + 3, "JOGO PAUSADO", 1.8, 1.8, 0);
            draw_set_color(c_yellow);
            draw_text_transformed(_cx, _cy - _card_h/2 + 40, "JOGO PAUSADO", 1.8, 1.8, 0);
        }

        // --- 4. Desenha as Opções do Menu de Pausa ---
        var _opts = (state == "main") ? main_options : confirm_options;
        var _start_y = (state == "main") ? _cy - ((array_length(main_options) - 1) * 55) / 2 + 20 : _cy - 30;
        var _gap = (state == "main") ? 55 : 50;
        
        for (var _i = 0; _i < array_length(_opts); _i++) {
            var _is_selected = (_i == index);
            var _color = _is_selected ? c_yellow : c_white;
            var _prefix = "";
            var _scale = 1.0;
            
            // Cabeçalho vermelho no menu de confirmação
            if (state == "confirm" && _i == 0) {
                draw_set_color(c_red);
                draw_text_transformed(_cx, _start_y + (_i * _gap), _opts[_i], 1.4, 1.4, 0);
                continue;
            }
            
            if (_is_selected) {
                _scale = 1.2 + sin(pulse_timer * 5.0) * 0.04;
                _prefix = "▶ ";
                
                // Destaque sob a opção selecionada
                draw_set_color(c_yellow);
                draw_set_alpha(0.12);
                draw_roundrect_ext(_cx - 150, _start_y + (_i * _gap) - 18, _cx + 150, _start_y + (_i * _gap) + 18, 10, 10, false);
                draw_set_alpha(1.0);
            }
            
            var _txt = _opts[_i];
            if (state == "main") {
                if (_txt == "Volume") {
                    _txt = "Volume: " + string(round(global.master_volume * 100)) + "%";
                } else if (_txt == "Mudo") {
                    _txt = "Mudo: " + (global.master_mute ? "Sim" : "Não");
                }
            }
            
            draw_set_color(_color);
            draw_text_transformed(_cx, _start_y + (_i * _gap), _prefix + _txt, _scale, _scale, 0);
        }
    };
}