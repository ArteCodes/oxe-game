// Ricochete nas paredes
if (tilemap_get_at_pixel(tilemap, x + vx + 4, y) > 0 ||
    tilemap_get_at_pixel(tilemap, x + vx - 4, y) > 0) {
    vx = -vx;
}
if (tilemap_get_at_pixel(tilemap, x, y + vy + 4) > 0 ||
    tilemap_get_at_pixel(tilemap, x, y + vy - 4) > 0) {
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
