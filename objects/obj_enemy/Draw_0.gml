// 1. Feedback visual de preparação de ataque (melee)
if (enemy_ai != undefined && enemy_ai.melee_preparing) {
    // Pisca entre vermelho e branco para alertar o jogador
    image_blend = (current_time div 80 % 2 == 0) ? c_red : c_white;
} else {
    image_blend = c_white;
}

draw_self(); 

// 2. Verifica se o sistema modular está no estado de carregamento ("charging")
if (enemy_ai != undefined && enemy_ai.state == "charging") {
    
    // Define a cor do rastro (ex: vermelho) e a transparência
    draw_set_colour(c_red); 
    draw_set_alpha(0.3);

    // Calcula a posição final da linha baseada na direção travada da investida
    // Usamos o dash_dir que foi salvo na struct quando o ataque começou
    var _dist_rastro = 200; // Comprimento visual do rastro
    var _target_x = x + lengthdir_x(_dist_rastro, enemy_ai.dash_dir);
    var _target_y = y + lengthdir_y(_dist_rastro, enemy_ai.dash_dir);

    // Desenha uma linha larga ou retângulo representando o caminho [5, 6]
    draw_line_width(x, y, _target_x, _target_y, 15); 

    // IMPORTANTE: Resetar o alpha e a cor para não afetar outros desenhos do jogo [4, 7]
    draw_set_alpha(1); 
    draw_set_colour(c_white);
}

// 3. Desenha o efeito de "corte" (melee) se estiver ativo
if (enemy_ai != undefined && enemy_ai.melee_active) {
    var _player = obj_player;
    if (instance_exists(_player)) {
        var _dir = point_direction(x, y, _player.x, _player.y);
        draw_set_colour(c_white);
        draw_set_alpha(0.8);
        
        // Desenha 3 linhas para simular as garras
        for (var i = -1; i <= 1; i++) {
            var _angle = _dir + (i * 25);
            var _x1 = x + lengthdir_x(10, _angle);
            var _y1 = y + lengthdir_y(10, _angle);
            var _x2 = x + lengthdir_x(40, _angle);
            var _y2 = y + lengthdir_y(40, _angle);
            draw_line_width(_x1, _y1, _x2, _y2, 3);
        }
        
        draw_set_alpha(1);
    }
}