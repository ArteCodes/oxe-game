// --- Sai se o player nao existe ---
if (!instance_exists(obj_player)) exit;

// --- Lê os dados do player via getters e propriedades publicas ---
var _hearts        = obj_player.hp.hearts;
var _max_hearts    = obj_player.hp.max_hearts;
var _charge_ratio  = obj_player.slingshot.get_charge_ratio();
var _reload_ratio  = obj_player.ball.get_reload_ratio();
// var _stone_count = obj_player.inventory.count; // ativar quando InventorySystem existir

var _ww = display_get_gui_width();
var _wh = display_get_gui_height();

// -----------------------------------------------------------------------
// CORACOES
// -----------------------------------------------------------------------
var _cx = 48;
var _cy = 48;
var _scale = (_max_hearts > 0) ? (_hearts / _max_hearts) : 0;

// Camada de fundo — coracao vazio no tamanho maximo
draw_sprite_ext(spr_heart_2, 0, _cx, _cy, 1, 1, 0, c_white, 1);

// Camada de frente — coracao cheio que encolhe com a vida
if (_scale > 0) {
    draw_sprite_ext(spr_heart_1, 0, _cx, _cy, _scale, _scale, 0, c_white, 1);
}

// -----------------------------------------------------------------------
// BARRA DE CARREGAMENTO DO ESTILINGUE
// -----------------------------------------------------------------------
if (_charge_ratio > 0) {
    var _bx  = _ww * 0.05;
    var _by  = _wh * 0.83;
    var _bw  = 80;
    var _bh  = 6;

    draw_set_color(c_dkgray);
    draw_set_alpha(0.6);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    draw_set_color((_charge_ratio >= 1) ? c_yellow : c_white);
    draw_set_alpha(1);
    draw_rectangle(_bx, _by, _bx + (_bw * _charge_ratio), _by + _bh, false);

    draw_set_alpha(1);
}

// -----------------------------------------------------------------------
// BARRA DE RECARGA DA BOLSA (tecla R)
// -----------------------------------------------------------------------
if (_reload_ratio > 0) {
    var _bx = _ww * 0.05;
    var _by = _wh * 0.91;
    var _bw = 80;
    var _bh = 6;

    draw_set_color(c_dkgray);
    draw_set_alpha(0.6);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    draw_set_color(c_aqua);
    draw_set_alpha(1);
    draw_rectangle(_bx, _by, _bx + (_bw * _reload_ratio), _by + _bh, false);

    draw_set_alpha(1);
}
