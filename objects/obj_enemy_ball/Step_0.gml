// Ricochete nas paredes e portas fechadas
var _collide_x = false;
if (tilemap_get_at_pixel(tilemap, x + vx + 4, y) > 0 ||
    tilemap_get_at_pixel(tilemap, x + vx - 4, y) > 0) {
    _collide_x = true;
} else {
    // Portas normais / do boss
    var _door_x1 = instance_place(x + vx + 4, y, obj_wall_door);
    var _door_x2 = instance_place(x + vx - 4, y, obj_wall_door);
    if ((_door_x1 != noone && (_door_x1.door_sys == undefined || !_door_x1.door_sys.is_opening)) ||
        (_door_x2 != noone && (_door_x2.door_sys == undefined || !_door_x2.door_sys.is_opening))) {
        _collide_x = true;
    } else {
        // Portas de pedra
        var _sdoor_x1 = instance_place(x + vx + 4, y, obj_stone_door);
        var _sdoor_x2 = instance_place(x + vx - 4, y, obj_stone_door);
        if ((_sdoor_x1 != noone && (_sdoor_x1.x == _sdoor_x1.x_start && _sdoor_x1.y == _sdoor_x1.y_start)) ||
            (_sdoor_x2 != noone && (_sdoor_x2.x == _sdoor_x2.x_start && _sdoor_x2.y == _sdoor_x2.y_start))) {
            _collide_x = true;
        }
    }
}
if (_collide_x) {
    vx = -vx;
}

var _collide_y = false;
if (tilemap_get_at_pixel(tilemap, x, y + vy + 4) > 0 ||
    tilemap_get_at_pixel(tilemap, x, y + vy - 4) > 0) {
    _collide_y = true;
} else {
    // Portas normais / do boss
    var _door_y1 = instance_place(x, y + vy + 4, obj_wall_door);
    var _door_y2 = instance_place(x, y + vy - 4, obj_wall_door);
    if ((_door_y1 != noone && (_door_y1.door_sys == undefined || !_door_y1.door_sys.is_opening)) ||
        (_door_y2 != noone && (_door_y2.door_sys == undefined || !_door_y2.door_sys.is_opening))) {
        _collide_y = true;
    } else {
        // Portas de pedra
        var _sdoor_y1 = instance_place(x, y + vy + 4, obj_stone_door);
        var _sdoor_y2 = instance_place(x, y + vy - 4, obj_stone_door);
        if ((_sdoor_y1 != noone && (_sdoor_y1.x == _sdoor_y1.x_start && _sdoor_y1.y == _sdoor_y1.y_start)) ||
            (_sdoor_y2 != noone && (_sdoor_y2.x == _sdoor_y2.x_start && _sdoor_y2.y == _sdoor_y2.y_start))) {
            _collide_y = true;
        }
    }
}
if (_collide_y) {
    vy = -vy;
}
x += vx;
y += vy;

// Dano ao tocar o jogador
if (instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) < 16) {
        obj_player.hp.take_damage(x, y, obj_player.x, obj_player.y);
        instance_destroy();
    }
}
