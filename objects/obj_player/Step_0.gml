// --- 1. Le input ---
var _ix = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _iy = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// --- 2. Dodge ---
if (mouse_check_button_pressed(mb_left) && dodge.can_dodge()) {
    dodge.try_dodge(_ix, _iy);
    movement.stop();
    slingshot.cancel(); // cancela carregamento se comecar o dodge
}

// --- 3. Atualiza dodge ---
var _dv = dodge.update(x, y, collision);

// --- 4. Estilingue ---
var _can_shoot = dodge.can_act() && ball.can_fire();
slingshot.update(mouse_check_button(mb_right), _can_shoot);

// --- 5. Movimento normal (bloqueado durante dodge) ---
// Velocidade reduzida a 50% durante carregamento
movement.max_speed = slingshot.is_charging ? 2 : 4;

if (dodge.can_act()) {
    movement.move(_ix, _iy);
}
movement.apply_friction();

// --- 6. Colisao com paredes ---
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// --- 7. Aplica posicao ---
if (dodge.is_dodging) {
    x += _dv.vx;
    y += _dv.vy;
} else {
    x += movement.vx;
    y += movement.vy;
}

// --- 8. Coleta da bolinha no chao ---
if (ball.state == ball.FLOOR && instance_exists(ball.ball_ref)) {
    if (point_distance(x, y, ball.ball_ref.x, ball.ball_ref.y) < 16) {
        ball.on_ball_collected();
    }
}

// --- 9. Sprite ---
sprite_index = spr_player_temp;
if (dodge.is_dodging) {
    image_speed = 0;
} else if (movement.is_moving()) {
    image_speed = 1;
} else {
    image_speed = 0;
    image_index = 0;
}