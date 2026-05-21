// --- 0. Configurações Globais (Garante Janela ao trocar de sala) ---
if (current_room_track != room) {
    // Se não estiver em tela cheia (ou se quisermos forçar a saída), garante o tamanho
    if (window_get_fullscreen()) {
        window_set_fullscreen(false);
    }
    if (variable_global_exists("player_window_width") && variable_global_exists("player_window_height")) {
        window_set_size(global.player_window_width, global.player_window_height);
    } else {
        window_set_size(1280, 720);
        global.player_window_width = 1280;
        global.player_window_height = 720;
    }
    window_center();
    current_room_track = room;
}

// Sincroniza dinamicamente o tamanho do GUI e a viewport da câmera com a janela do jogo caso o usuário a redimensione
if (window_get_width() > 0 && window_get_height() > 0) {
    if (display_get_gui_width() != window_get_width() || display_get_gui_height() != window_get_height()) {
        var _ww = window_get_width();
        var _wh = window_get_height();
        display_set_gui_size(_ww, _wh);
        
        surface_resize(application_surface, _ww, _wh);
        view_set_wport(0, _ww);
        view_set_hport(0, _wh);
        
        global.player_window_width = _ww;
        global.player_window_height = _wh;
    }
}

// Atalho manual para trocar entre janela e tela cheia (F4)
if (keyboard_check_pressed(vk_f4)) {
    window_set_fullscreen(!window_get_fullscreen());
}

// --- 0. Pausa ---
if (keyboard_check_pressed(vk_escape)) {
    if (!instance_exists(obj_pause)) {
        safe_create_layer(0, 0, "Instances", obj_pause);
        exit; // Interrompe o resto do Step para o player não se mover no frame da pausa
    }
}
// --- 0.1. colisssão temporaria ---
if (porta_1_aberta == true && collision_temp_1 != undefined) {
    collision_temp_1 = undefined;
}


// --- 0.2. Estado de Morte Animada ---
if (hp.dead) {
    movement.stop();
    slingshot.cancel();
    
    if (sprite_index != spr_player_death) {
        sprite_index = spr_player_death;
        image_index = 0;
        image_speed = 0.4; // Deixa a morte mais lenta e dramática
    }
    
    // Trava no último frame da animação
    if (image_index >= image_number - 1) {
        image_speed = 0;
        image_index = image_number - 1;
        
        // Cria a tela de morte (Game Over) quando a animação terminar
        if (!instance_exists(obj_death_screen)) {
            safe_create_layer(0, 0, "Instances", obj_death_screen);
        }
    }
    
    // Suaviza a parada caso o player estivesse correndo ao morrer
    movement.apply_friction();
    x += movement.vx;
    y += movement.vy;
    
    // Mantém a câmera atualizada
    camera.update();
    exit; // Ignora o resto de todo o step event (bloqueia input/combate)
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
var _dv = dodge.update(x, y, collision_cheia, collision_meia); 

// --- 3. Estilingue ---
var _can_shoot = dodge.can_act() && ball.can_fire();
slingshot.update(mouse_check_button(mb_right), _can_shoot);

// --- 4. Recarga da bolsa ---
ball.update_reload(mouse_check_button(mb_left));

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
movement.vx = collision_barrel.resolve_x(x, y, movement.vx);

movement.vy = collision_cheia.resolve_y(x, y, movement.vy);
movement.vy = collision_meia.resolve_y(x, y, movement.vy);
movement.vy = collision_barrel.resolve_y(x, y, movement.vy);

if (collision_temp_1 != undefined) {
    movement.vy = collision_temp_1.resolve_y(x, y, movement.vy);
}

// --- 8. Aplica posicao ---
if (dodge.is_dodging) {
    // Colisão com porta durante a esquiva (dodge)
    if (place_meeting(x + _dv.vx, y, obj_wall_door)) {
        var _door_x = instance_place(x + _dv.vx, y, obj_wall_door);
        if (_door_x != noone && (_door_x.door_sys == undefined || !_door_x.door_sys.is_opening)) {
            if (_dv.vx != 0) {
                while (!place_meeting(x + sign(_dv.vx), y, _door_x)) {
                    x += sign(_dv.vx);
                }
            }
            _dv.vx = 0;
            dodge._dodge_vx = 0;
        }
    }
    x += _dv.vx;
    
    if (place_meeting(x, y + _dv.vy, obj_wall_door)) {
        var _door_y = instance_place(x, y + _dv.vy, obj_wall_door);
        if (_door_y != noone && (_door_y.door_sys == undefined || !_door_y.door_sys.is_opening)) {
            if (_dv.vy != 0) {
                while (!place_meeting(x, y + sign(_dv.vy), _door_y)) {
                    y += sign(_dv.vy);
                }
            }
            _dv.vy = 0;
            dodge._dodge_vy = 0;
        }
    }
    y += _dv.vy;
} else {
    // Colisão com porta durante o movimento normal
    if (place_meeting(x + movement.vx, y, obj_wall_door)) {
        var _door_x = instance_place(x + movement.vx, y, obj_wall_door);
        if (_door_x != noone && (_door_x.door_sys == undefined || !_door_x.door_sys.is_opening)) {
            if (movement.vx != 0) {
                while (!place_meeting(x + sign(movement.vx), y, _door_x)) {
                    x += sign(movement.vx);
                }
            }
            movement.vx = 0;
        }
    }
    x += movement.vx;
    
    if (place_meeting(x, y + movement.vy, obj_wall_door)) {
        var _door_y = instance_place(x, y + movement.vy, obj_wall_door);
        if (_door_y != noone && (_door_y.door_sys == undefined || !_door_y.door_sys.is_opening)) {
            if (movement.vy != 0) {
                while (!place_meeting(x, y + sign(movement.vy), _door_y)) {
                    y += sign(movement.vy);
                }
            }
            movement.vy = 0;
        }
    }
    y += movement.vy;
}

// --- 8b. Knockback e i-frames ---
var _kb = hp.update();
if (_kb.vx != 0 || _kb.vy != 0) {
    // 1. Resolve a colisão no eixo X passando por ambos os sistemas
    var _kbx = collision_cheia.resolve_x(x, y, _kb.vx);
    _kbx = collision_meia.resolve_x(x, y, _kbx); 
    
    // 2. Resolve a colisão no eixo Y passando por ambos os sistemas
    var _kby = collision_cheia.resolve_y(x, y, _kb.vy);
    _kby = collision_meia.resolve_y(x, y, _kby);

    // Opcional: Se você ainda estiver usando a parede invisível temporária
    if (collision_temp_1 != undefined) {
        _kbx = collision_temp_1.resolve_x(x, y, _kbx);
        _kby = collision_temp_1.resolve_y(x, y, _kby);
    }
    
    // Colisão do Knockback com a porta
    if (place_meeting(x + _kbx, y, obj_wall_door)) {
        var _door_x = instance_place(x + _kbx, y, obj_wall_door);
        if (_door_x != noone && (_door_x.door_sys == undefined || !_door_x.door_sys.is_opening)) {
            if (_kbx != 0) {
                while (!place_meeting(x + sign(_kbx), y, _door_x)) {
                    x += sign(_kbx);
                }
            }
            _kbx = 0;
        }
    }
    x += _kbx;
    
    if (place_meeting(x, y + _kby, obj_wall_door)) {
        var _door_y = instance_place(x, y + _kby, obj_wall_door);
        if (_door_y != noone && (_door_y.door_sys == undefined || !_door_y.door_sys.is_opening)) {
            if (_kby != 0) {
                while (!place_meeting(x, y + sign(_kby), _door_y)) {
                    y += sign(_kby);
                }
            }
            _kby = 0;
        }
    }
    y += _kby;
}
// Pisca durante i-frames
if (hp.iframes > 0) {
    image_alpha = (hp.iframes mod 6 < 3) ? 0.3 : 1.0;
} else {
    image_alpha = 1.0;
}

// Morte (gerenciada no topo do Step para tocar a animação de morte)

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

// --- 12. DEBUG/INTERATIVE: Atalho para ligar/desligar o Fog (Tecla 'F') ---
if (keyboard_check_pressed(ord("F"))) {
    if (instance_exists(obj_fog)) {
        instance_destroy(obj_fog);
        effect_create_above(ef_smoke, x, y, 1, c_white);
    } else {
        safe_create_layer(x, y, "Instances", obj_fog);
    }
}

// --- Animação Visual do Estilingue ---
if (slingshot.is_charging) {
    // Estica o elástico baseado no tempo de carga (até 12 pixels)
    slingshot_visual_stretch = (slingshot.charge_time / slingshot.CHARGE_MAX) * 12;
} else {
    // Se soltou o tiro e tinha tensão, aplica recoil
    if (slingshot_visual_stretch > 0) {
        slingshot_recoil = slingshot_visual_stretch;
        slingshot_visual_stretch = 0;
    }
    // Suaviza o recoil (o elástico voltando)
    slingshot_recoil = lerp(slingshot_recoil, 0, 0.2);
}

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
            // Se for uma porta (objetos que tem a variável target_room definida no Create)
            if (variable_instance_exists(_alvo, "target_room")) {
                // Só teleporta se não houver mais inimigos
                if (instance_number(obj_enemy_parent) <= 0) {
                    if (room_exists(_alvo.target_room)) {
                        room_goto(_alvo.target_room);
                    }
                }
            } else {
                // Caso contrário, é um NPC normal: inicia diálogo
                npc_foco = _alvo; 
                dialogo.iniciar(_alvo.falas);
            }
        }
    }
}