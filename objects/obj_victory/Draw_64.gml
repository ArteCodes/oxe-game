// --- Evento Draw GUI (Draw_64) do obj_victory ---

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

// --- 1. Paleta de Cores Coesa ---
var _color_top    = make_color_rgb(18, 12, 25);     // Indigo/Preto crepúsculo profundo
var _color_bottom = make_color_rgb(120, 25, 45);    // Vermelho coral pôr do sol
var _color_gold   = make_color_rgb(255, 185, 45);   // Dourado pôr do sol vibrante
var _color_cream  = make_color_rgb(240, 230, 210);  // Creme suave

// --- 2. Fundo com Gradiente Vertical do Pôr do Sol ---
draw_rectangle_color(0, 0, _gui_w, _gui_h, _color_top, _color_top, _color_bottom, _color_bottom, false);

// --- 3. Efeito Visual de Sol no Centro (Brilho Atmosférico) ---
var _sun_y = _cy - 50;
draw_set_color(make_color_rgb(230, 80, 35));
draw_set_alpha(0.12 + sin(pulse_timer * 1.5) * 0.02);
draw_circle(_cx, _sun_y, 180, false);

draw_set_color(make_color_rgb(255, 160, 45));
draw_set_alpha(0.25 + sin(pulse_timer * 2.0) * 0.03);
draw_circle(_cx, _sun_y, 110, false);
draw_set_alpha(1.0);

// --- 4. Título Principal "VITÓRIA!" ---
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Sombra do título
draw_set_color(c_black);
draw_set_alpha(0.4);
draw_text_transformed(_cx + 4, _cy - 120 + 4, "VITORIA!", 3.2, 3.2, 0);

// Título dourado brilhante
draw_set_color(_color_gold);
draw_set_alpha(1.0);
draw_text_transformed(_cx, _cy - 120, "VITORIA!", 3.2, 3.2, 0);

// --- 5. Mensagem de Agradecimento ---
draw_set_color(_color_cream);
draw_text_transformed(_cx, _cy - 40, "Obrigado por jogar!", 1.5, 1.5, 0);

// Subtexto narrativo elegante
draw_set_color(_color_cream);
draw_set_alpha(0.7);
draw_text_transformed(_cx, _cy + 10, "O reino dos caranguejos foi libertado graças a você.", 1.0, 1.0, 0);
draw_set_alpha(1.0);

// --- 6. Desenho do Botão "VOLTAR AO INÍCIO" ---
var _cy_btn = _cy + 120;
var _scale = button_hover ? (1.05 + sin(pulse_timer * 8) * 0.015) : (1.0 + sin(pulse_timer * 3) * 0.015);
var _bw = 280 * _scale;
var _bh = 50 * _scale;
var _bx1 = _cx - _bw/2;
var _by1 = _cy_btn - _bh/2;
var _bx2 = _cx + _bw/2;
var _by2 = _cy_btn + _bh/2;

// Sombra do botão
draw_set_color(c_black);
draw_set_alpha(0.35);
draw_roundrect_ext(_bx1 - 3, _by1 + 3, _bx2 + 3, _by2 + 3, 12, 12, false);

// Corpo do botão
if (button_hover) {
    // Fundo dourado sólido
    draw_set_color(_color_gold);
    draw_set_alpha(1.0);
    draw_roundrect_ext(_bx1, _by1, _bx2, _by2, 12, 12, false);
    
    // Borda de realce
    draw_set_color(c_white);
    draw_set_alpha(0.25);
    draw_roundrect_ext(_bx1, _by1, _bx2, _by2, 12, 12, true);
} else {
    // Fundo escuro translúcido estilo Glassmorphism
    draw_set_color(make_color_rgb(25, 20, 32));
    draw_set_alpha(0.8);
    draw_roundrect_ext(_bx1, _by1, _bx2, _by2, 12, 12, false);
    
    // Borda brilhante dourada
    draw_set_color(_color_gold);
    draw_set_alpha(0.4);
    draw_roundrect_ext(_bx1, _by1, _bx2, _by2, 12, 12, true);
}

// Texto do botão
draw_set_alpha(1.0);
draw_set_color(button_hover ? _color_top : _color_gold);
draw_text_transformed(_cx, _cy_btn - 1, "VOLTAR AO INICIO", _scale, _scale, 0);

// Indicadores nas laterais se hovered
if (button_hover) {
    var _offset = (_bw / 2) + 24 + sin(pulse_timer * 10) * 3;
    draw_set_color(_color_gold);
    draw_text_transformed(_cx - _offset, _cy_btn - 1, ">", _scale, _scale, 0);
    draw_text_transformed(_cx + _offset, _cy_btn - 1, "<", _scale, _scale, 0);
}

draw_set_font(-1);
