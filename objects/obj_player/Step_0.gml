// --- 0. Pausa --- bloqueia toda logica se o jogo estiver pausado
// Usa asset_get_index para nao crashar se obj_pause ainda nao existir no projeto
var _pause_asset = asset_get_index("obj_pause");
if (_pause_asset != -1 && instance_exists(_pause_asset)) {
    var _pause_inst = instance_find(_pause_asset, 0);
    if (_pause_inst != noone && _pause_inst.pause.is_paused) exit;
}

// --- 1. Input ---
var _ix = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _iy = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// --- 2. Dodge (tecla: Espaco) ---
if (keyboard_check_pressed(vk_space) && dodge.can_dodge()) {
    dodge.try_dodge(_ix, _iy);
    movement.stop();
    slingshot.cancel();
}

var _dv = dodge.update(x, y, collision);

// --- 3. Estilingue ---
var _can_shoot = dodge.can_act() && ball.can_fire() && !inventory.is_reloading;
slingshot.update(mouse_check_button(mb_right), _can_shoot);

// --- 4. Recarga da bolsa (tecla R — BallSystem) ---
ball.update_reload(keyboard_check(ord("R")));

// --- 5. Inventario --- atualiza timer de recarga e detecta coleta de pedra extra
var _reload_done = inventory.update();
if (_reload_done) {
    // recarga do estoque terminou — devolve a bolinha ao estilingue
    ball.state = ball.IDLE;
}

// --- 6. Velocidade maxima baseada no estado ---
if (inventory.is_reloading) {
    movement.max_speed = 0; // parado e vulneravel durante recarga do estoque
} else if (ball.is_reloading) {
    movement.max_speed = 0.8;
} else if (slingshot.is_charging) {
    movement.max_speed = 2;
} else {
    movement.max_speed = 4;
}

// --- 7. Movimento ---
if (dodge.can_act() && !inventory.is_reloading) {
    movement.move(_ix, _iy);
}
movement.apply_friction();

// --- 8. Colisao com paredes ---
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// --- 9. Aplica posicao ---
if (dodge.is_dodging) {
    x += _dv.vx;
    y += _dv.vy;
} else {
    x += movement.vx;
    y += movement.vy;
}

// --- 10. Knockback e i-frames ---
var _kb = hp.update();
if (_kb.vx != 0 || _kb.vy != 0) {
    x += collision.resolve_x(x, y, _kb.vx);
    y += collision.resolve_y(x, y, _kb.vy);
}

// Pisca durante i-frames
image_alpha = (hp.iframes > 0 && hp.iframes mod 6 < 3) ? 0.3 : 1.0;

// Morte
if (hp.dead) {
    room_restart(); // substituir por GameOverSystem quando estiver pronto
}

// --- 11. Coleta da bolinha no chao ---
if (ball.state == ball.FLOOR && instance_exists(ball.ball_ref)) {
    if (point_distance(x, y, ball.ball_ref.x, ball.ball_ref.y) < 16) {
        ball.on_ball_collected();
    }
}

// --- 12. Sprite ---
if (dodge.is_dodging) {
    image_speed = 3;
    switch (dodge.facing) {
        case 0: sprite_index = spr_player_run_D; break;
        case 1: sprite_index = spr_player_run_T; break;
        case 3: sprite_index = spr_player_run_R; break;
        case 2: sprite_index = spr_player_run_L; break;
    }
} else if (movement.is_moving()) {
    image_speed = 1.5;
    switch (movement.facing) {
        case 0: sprite_index = spr_player_run_D; break;
        case 1: sprite_index = spr_player_run_T; break;
        case 3: sprite_index = spr_player_run_R; break;
        case 2: sprite_index = spr_player_run_L; break;
    }
} else {
    image_speed = 1.5;
    switch (movement.facing) {
        case 0: sprite_index = spr_player_idle_D; break;
        case 1: sprite_index = spr_player_idle_T; break;
        case 3: sprite_index = spr_player_idle_R; break;
        case 2: sprite_index = spr_player_idle_L; break;
    }
}

// --- 13. Camera ---
camera.update();
