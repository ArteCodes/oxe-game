// Atira em direcao ao jogador periodicamente
shoot_timer++;
if (shoot_timer >= shoot_interval && instance_exists(obj_player)) {
    shoot_timer = 0;

    var _ball = safe_create_layer(x, y, "Instances", obj_enemy_ball);
    var _dir  = point_direction(x, y, obj_player.x, obj_player.y);
    _ball.vx  = lengthdir_x(4, _dir);
    _ball.vy  = lengthdir_y(4, _dir);
}