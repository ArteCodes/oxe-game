// 1. ATIVAÇÃO: Verifica se não está ativo para checar colisões
if (!is_active) {
    var _ball_hit = instance_place(x, y, obj_ball);
    if (_ball_hit == noone) {
        var _nearest_ball = instance_nearest(x, y, obj_ball);
        if (_nearest_ball != noone && point_distance(x, y, _nearest_ball.x, _nearest_ball.y) < 28) {
            _ball_hit = _nearest_ball;
        }
    }
    
    var _player_hit = instance_place(x, y, obj_player);
    if (_player_hit == noone) {
        var _nearest_player = instance_nearest(x, y, obj_player);
        if (_nearest_player != noone && point_distance(x, y, _nearest_player.x, _nearest_player.y) < 28) {
            _player_hit = _nearest_player;
        }
    }
    
    // Ativa se for atingido pela bolinha ou se o jogador pisar em cima
    if (_ball_hit != noone || _player_hit != noone) {
        is_active = true;
        
        // Define o tempo que ficará ativado
        timer = activation_time;
    }
}
// 2. DESATIVAÇÃO / CONTROLE DE TEMPO: Se ativo, trata de desativar quando necessário
else {
    // Mantém ativo enquanto o jogador estiver em cima, resetando o timer
    var _player_on = instance_place(x, y, obj_player);
    if (_player_on == noone) {
        var _nearest_player = instance_nearest(x, y, obj_player);
        if (_nearest_player != noone && point_distance(x, y, _nearest_player.x, _nearest_player.y) < 28) {
            _player_on = _nearest_player;
        }
    }
    if (_player_on != noone) {
        timer = activation_time;
    }
    
    // Se o timer estiver sendo controlado e não for permanente (-1)
    if (activation_time != -1) {
        timer--;
        if (timer <= 0) {
            is_active = false;
        }
    }
}
