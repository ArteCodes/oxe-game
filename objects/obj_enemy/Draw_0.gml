// 1. Desenha o próprio sprite do inimigo primeiro
draw_self(); 

// 2. Verifica se o sistema modular está no estado de carregamento ("charging")
if (enemy_ai.state == "charging") {
    
    // Define a cor do rastro (ex: vermelho) e a transparência
    draw_set_colour(c_red); // [3]
    draw_set_alpha(0.2);    // Deixa o rastro semitransparente [4]

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