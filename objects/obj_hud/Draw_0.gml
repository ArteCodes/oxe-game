if (!instance_exists(obj_player)) exit;

var _hearts = obj_player.hp.hearts;
var _max    = obj_player.hp.max_hearts;
var _scale  = _hearts / _max; // 3/3=1.0, 2/3=0.66, 1/3=0.33, 0/3=0.0

var _cx = 48; // posicao X na tela
var _cy = 48; // posicao Y na tela

// Camada de baixo — cinza fixo no tamanho maximo
draw_sprite_ext(spr_heart_2, 0, _cx, _cy, 1, 1, 0, c_white, 1);

// Camada de cima — vermelho que encolhe conforme perde vida
if (_scale > 0) {
    draw_sprite_ext(spr_heart_1, 0, _cx, _cy, _scale, _scale, 0, c_white, 1);
}