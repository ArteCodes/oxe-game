// --- Evento Draw do obj_enemy_red ---

draw_self(); 

// Desenha a marcação do dash enquanto carrega, igual ao obj_enemy
if (enemy_ai != undefined && enemy_ai.state == "charging") {
    draw_set_colour(c_red);
    draw_set_alpha(0.2);
    var _dist_rastro = 200;
    var _target_x = x + lengthdir_x(_dist_rastro, enemy_ai.dash_dir);
    var _target_y = y + lengthdir_y(_dist_rastro, enemy_ai.dash_dir);
    draw_line_width(x, y, _target_x, _target_y, 15);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

// Desenha o círculo de aviso da área de explosão
if (enemy_ai != undefined && enemy_ai.explosion_warning) {
    var _range = enemy_ai.explosion_range;
    var _alpha = enemy_ai.explosion_circle_alpha;
    
    // Círculo preenchido semi-transparente (vermelho)
    draw_set_alpha(_alpha * 0.3);
    draw_set_colour(c_red);
    draw_circle(x, y, _range, false);
    
    // Contorno do círculo (mais visível)
    draw_set_alpha(_alpha);
    draw_set_colour(c_red);
    draw_circle(x, y, _range, true);
    
    // Reseta
    draw_set_alpha(1);
    draw_set_colour(c_white);

    // DEBUG: desenha vetor de movimento se habilitado
    if (variable_instance_exists(self, "debug_draw_vector") && debug_draw_vector) {
        var _vx = movement.vx;
        var _vy = movement.vy;
        draw_set_colour(c_yellow);
        draw_line_width(x, y, x + _vx * 8, y + _vy * 8, 2);
        draw_circle(x + _vx * 8, y + _vy * 8, 4, true);
        draw_set_colour(c_white);
    }
}
