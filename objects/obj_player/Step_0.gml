// --- 1. Input ---
var _ix = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _iy = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// --- 2. Dodge ---
// Botao esquerdo — cancela o carregamento se estiver carregando
if (mouse_check_button_pressed(mb_left) && dodge.can_dodge()) {
    dodge.try_dodge(_ix, _iy);
    movement.stop();
    slingshot.cancel();
}
var _dv = dodge.update(x, y, collision);

// --- 3. Estilingue ---
// So pode carregar fora do dodge e sem bolinha ativa
var _can_shoot = dodge.can_act() && ball.can_fire();
slingshot.update(mouse_check_button(mb_right), _can_shoot);

// --- 4. Recarga da bolsa ---
// Segurar R com bolinha ativa ou no chao inicia a recarga
ball.update_reload(keyboard_check(ord("R")));

// --- 5. Velocidade maxima baseada no estado atual ---
if (ball.is_reloading) {
    movement.max_speed = 0.8; // quase imovil durante recarga
} else if (slingshot.is_charging) {
    movement.max_speed = 2;   // reduzido ao carregar estilingue
} else {
    movement.max_speed = 4;   // velocidade normal
}

// --- 6. Movimento ---
if (dodge.can_act()) {
    movement.move(_ix, _iy);
}
movement.apply_friction();

// --- 7. Colisao com paredes ---
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// --- 8. Aplica posicao ---
// Durante o dodge usa velocidade do deslize, fora usa o movimento normal
if (dodge.is_dodging) {
    x += _dv.vx;
    y += _dv.vy;
} else {
    x += movement.vx;
    y += movement.vy;
}

// --- 8b. Knockback e i-frames ---
var _kb = hp.update();
if (_kb.vx != 0 || _kb.vy != 0) {
    // Knockback respeita colisao com paredes
    var _kbx = collision.resolve_x(x, y, _kb.vx);
    var _kby = collision.resolve_y(x, y, _kb.vy);
    x += _kbx;
    y += _kby;
}

// Pisca durante i-frames
image_alpha = (hp.iframes mod 6 < 3) ? 0.3 : 1.0;

// Morte
if (hp.dead) {
    room_restart();
}

// --- 9. Coleta da bolinha no chao ---
// Coleta automatica ao passar por cima da bolinha parada
if (ball.state == ball.FLOOR && instance_exists(ball.ball_ref)) {
    if (point_distance(x, y, ball.ball_ref.x, ball.ball_ref.y) < 16) {
        ball.on_ball_collected();
    }
}

// --- 10. Sprite ---
sprite_index = spr_player;

if (dodge.is_dodging) {
    image_speed = 2;
    switch (dodge.facing) {
        case 0: image_index = 4  + (image_index mod 4); break; // deslize baixo
        case 1: image_index = 12 + (image_index mod 4); break; // deslize cima
        case 3: image_index = 20 + (image_index mod 4); break; // deslize direita
        case 2: image_index = 28 + (image_index mod 4); break; // deslize esquerda
    }
} else if (movement.is_moving()) {
    image_speed = 2;
    switch (movement.facing) {
        case 0: image_index = 4  + (image_index mod 4); break; // andar baixo
        case 1: image_index = 12 + (image_index mod 4); break; // andar cima
        case 3: image_index = 20 + (image_index mod 4); break; // andar direita
        case 2: image_index = 28 + (image_index mod 4); break; // andar esquerda
    }
} else {
    image_speed = 1;
    switch (movement.facing) {
        case 0: image_index = 0  + (image_index mod 4); break; // idle baixo
        case 1: image_index = 8  + (image_index mod 4); break; // idle cima
        case 3: image_index = 16 + (image_index mod 4); break; // idle direita
        case 2: image_index = 24 + (image_index mod 4); break; // idle esquerda
    }
}