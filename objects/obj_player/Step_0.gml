// --- 0. Pausa ---
if (keyboard_check_pressed(vk_escape)) {
    if (!instance_exists(obj_pause)) {
        instance_create_layer(0, 0, "Instances", obj_pause);
        exit; // Interrompe o resto do Step para o player não se mover no frame da pausa
    }
}
// --- 0.1. colisssão temporaria ---
if (porta_1_aberta == true && collision_temp_1 != undefined) {
    collision_temp_1 = undefined;
}


// --- 1. Input ---
var _ix = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _iy = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// --- 2. Dodge ---
if (keyboard_check(vk_space) && dodge.can_dodge()) {
    dodge.try_dodge(_ix, _iy);
    movement.stop();
    slingshot.cancel();
}
// Ajuste: O Dodge precisa saber com qual colisão checar. 
// Se o dash deve colidir com tudo, você precisará rodar o update para ambos ou escolher o principal.
var _dv = dodge.update(x, y, collision_cheia); 

// --- 3. Estilingue ---
var _can_shoot = dodge.can_act() && ball.can_fire();
slingshot.update(mouse_check_button(mb_right), _can_shoot);

// --- 4. Recarga da bolsa ---
ball.update_reload(keyboard_check(ord("R")));

// --- 5. Velocidade maxima baseada no estado atual ---
if (ball.is_reloading) {
    movement.max_speed = 0.8;
} else if (slingshot.is_charging) {
    movement.max_speed = 2;
} else {
    movement.max_speed = 4;
}

// --- 6. Movimento ---
if (dodge.can_act()) {
    movement.move(_ix, _iy);
}
movement.apply_friction();

// --- 7. Colisao com paredes ---
movement.vx = collision_cheia.resolve_x(x, y, movement.vx);
movement.vx = collision_meia.resolve_x(x, y, movement.vx);

movement.vy = collision_cheia.resolve_y(x, y, movement.vy);
movement.vy = collision_meia.resolve_y(x, y, movement.vy);

if (collision_temp_1 != undefined) {
    movement.vy = collision_temp_1.resolve_y(x, y, movement.vy);
}

// --- 8. Aplica posicao ---
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
    var _kbx = collision.resolve_x(x, y, _kb.vx);
    var _kby = collision.resolve_y(x, y, _kb.vy);
    x += _kbx;
    y += _kby;
}

// Pisca durante i-frames
if (hp.iframes > 0) {
    image_alpha = (hp.iframes mod 6 < 3) ? 0.3 : 1.0;
} else {
    image_alpha = 1.0;
}

// Morte
if (hp.dead) {
    room_restart();
}

// --- 9. Coleta da bolinha no chao ---
if (ball.state == ball.FLOOR && instance_exists(ball.ball_ref)) {
    if (point_distance(x, y, ball.ball_ref.x, ball.ball_ref.y) < 16) {
        ball.on_ball_collected();
    }
}

// --- 10. Sprite ---
var _prev_sprite = sprite_index; // guarda o sprite atual antes de trocar

if (dodge.is_dodging) {
    image_speed = 3;    
    switch (dodge.facing) {
        case 0: sprite_index = spr_player_run_D; break;
        case 1: sprite_index = spr_player_run_T; break;
        case 3: sprite_index = spr_player_dash_R; break;
        case 2: sprite_index = spr_player_dash_L; break;
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

// Se trocou de sprite, reseta pro frame 0
if (sprite_index != _prev_sprite) {
    image_index = 0;
}
// --- 11. Camera ---
camera.update();

// --- 1b. Interação / Diálogo ---
dialogo.atualizar(); // Faz as letras aparecerem gradativamente [1]

// Verifica se o diálogo JÁ está rodando
if (dialogo.ativo == true) {
    
    // Se o NPC deixou de existir OU o jogador andou para longe (mais de 80 pixels)
    if (!instance_exists(npc_foco) || point_distance(x, y, npc_foco.x, npc_foco.y) > 80) {
        dialogo.ativo = false; // Fecha o balão de diálogo sozinho!
    }
    
    // Se o jogador apertar E enquanto a caixa está aberta (e ele continua perto)
    else if (keyboard_check_pressed(ord("E"))) {
        dialogo.proxima_linha(); 
    }
} 
// Se o diálogo está desligado, procura um NPC perto para iniciar
else {
    if (keyboard_check_pressed(ord("E"))) {
        var _alvo = instance_nearest(x, y, obj_interagivel);
        
        if (_alvo != noone && point_distance(x, y, _alvo.x, _alvo.y) < 80) {
            npc_foco = _alvo; 
            dialogo.iniciar(_alvo.falas);
        }
    }
}