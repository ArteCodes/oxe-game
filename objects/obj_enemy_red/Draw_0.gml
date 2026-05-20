// --- Evento Draw do obj_enemy_red ---

draw_self(); 

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
}
