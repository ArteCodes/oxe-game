if (collect_delay > 0) collect_delay--;

// Guarda posição no rastro
ds_list_add(trail, { tx: x, ty: y });
if (ds_list_size(trail) > trail_max) {
    ds_list_delete(trail, 0);
}

// Quanto de distância ainda resta
var _ratio = 1 - (distance_traveled / max_distance);
var _current_speed = initial_speed * (_ratio);

// Ricochete — só inverte direção, não muda velocidade
if (tilemap_get_at_pixel(tilemap, x + vx + 4, y) > 0 ||
    tilemap_get_at_pixel(tilemap, x + vx - 4, y) > 0) {
    vx = -vx;
}
if (tilemap_get_at_pixel(tilemap, x, y + vy + 4) > 0 ||
    tilemap_get_at_pixel(tilemap, x, y + vy - 4) > 0) {
    vy = -vy;
}

// Mantém a direção atual e aplica velocidade por distância
var _dir = point_direction(0, 0, vx, vy);
if (vx != 0 || vy != 0) {
    vx = lengthdir_x(_current_speed, _dir);
    vy = lengthdir_y(_current_speed, _dir);
}

// Move
x += vx;
y += vy;

// Acumula distância
distance_traveled += _current_speed;

// Para ao atingir distância máxima
if (distance_traveled >= max_distance) {
    vx = 0;
    vy = 0;
    if (instance_exists(owner)) {
        owner.ball.on_ball_stopped(id);
    }
}

// Coleta por proximidade
if (collect_delay <= 0 && instance_exists(owner)) {
    if (point_distance(x, y, owner.x, owner.y) < 16) {
        owner.ball.on_ball_collected();
    }
}