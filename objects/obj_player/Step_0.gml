// --- 1. Lê input ---
var _ix = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _iy = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// --- 2. Dodge ---
if (mouse_check_button_pressed(mb_left) && dodge.can_dodge()) {
    dodge.try_dodge(_ix, _iy);
    movement.stop();
}

// --- 3. Atualiza dodge (passa posição e colisão para checar paredes) ---
var _dv = dodge.update(x, y, collision);

// --- 4. Movimento normal (bloqueado durante o dodge) ---
if (dodge.can_act()) {
    movement.move(_ix, _iy);
}
movement.apply_friction();

// --- 5. Colisão do movimento normal com paredes ---
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// --- 6. Aplica posição ---
if (dodge.is_dodging) {
    x += _dv.vx;
    y += _dv.vy;
} else {
    x += movement.vx;
    y += movement.vy;
}

// --- 7. Atualiza sprite ---
    /*
	switch (movement.facing) {
        case 0: sprite_index = spr_player_down;  break;
        case 1: sprite_index = spr_player_up;    break;
        case 2: sprite_index = spr_player_left;  break;
        case 3: sprite_index = spr_player_right; break;
    }
	*/
// Trocar spr_player_temp pelos sprites reais quando tiver os assets
sprite_index = spr_player_temp;
if (dodge.is_dodging) {
    image_speed = 0;
} else if (movement.is_moving()) {
    image_speed = 1;
} else {
    image_speed = 0;
    image_index = 0;
}
// --- Disparo da bolinha ---
if (mouse_check_button_pressed(mb_right) && dodge.can_act()) {
    ball.try_fire(x, y, mouse_x, mouse_y, "Instances", id);
}

// --- Coleta ao passar por cima (estado FLOOR) ---
if (ball.state == ball.FLOOR) {
    if (point_distance(x, y, ball.ball_ref.x, ball.ball_ref.y) < 16) {
        ball.on_ball_collected();
    }
}