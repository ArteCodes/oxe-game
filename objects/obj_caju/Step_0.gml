// --- Evento Etapa (Step) do obj_caju ---

// Garante profundidade correta na tela
depth = -y;

// Colisão com o jogador para cura de 1 de vida
if (instance_exists(obj_player)) {
    var _player = obj_player;
    
    // Apenas coleta e atrai se o player não estiver com a vida cheia (conforme pedido pelo usuário)
    if (_player.hp.hearts < _player.hp.max_hearts) {
        var _dist = point_distance(x, y, _player.x, _player.y);
        
        // Efeito magnético premium: atrai o caju na direção do jogador se estiver perto (60 pixels)
        if (_dist < 60) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            var _spd = 4.5 * (1 - (_dist / 60)); // Aumenta a velocidade de sucção à medida que se aproxima
            x += lengthdir_x(_spd, _dir);
            y += lengthdir_y(_spd, _dir);
        }
        
        // Coleta e cura ao estar próximo (26 pixels) ou colidindo com a caixa de colisão do jogador
        if (_dist < 26 || place_meeting(x, y, obj_player)) {
            _player.hp.heal(1);
            
            // Efeito visual premium de cura (faíscas verdes e explosão suave de brilho)
            effect_create_above(ef_spark, x, y, 1, c_lime);
            effect_create_above(ef_ring, x, y, 0.5, c_green);
            
            // Destrói o item de cura
            instance_destroy();
        }
    }
}
