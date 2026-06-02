// --- Evento Step do obj_victory ---

pulse_timer += 0.05;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = _gui_w / 2;
var _cy = _gui_h / 2 + 120;
var _bw = 280;
var _bh = 50;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Hover interativo com o mouse
button_hover = (_mx >= _cx - _bw/2 && _mx <= _cx + _bw/2 && _my >= _cy - _bh/2 && _my <= _cy + _bh/2);

// Seleção por teclado (Enter/Espaço) ou clique do mouse
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || (button_hover && mouse_check_button_pressed(mb_left))) {
    audio_play_sound(snd_menu_button, 10, false);
    audio_stop_sound(snd_victory);
    room_goto(rm_main_menu);
}
