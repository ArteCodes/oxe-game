// --- Evento Passo (Step) ---

// 1. Adiciona posição atual ao rastro
ds_list_insert(trail_list, 0, {tx: x, ty: y});
if (ds_list_size(trail_list) > trail_max) {
    ds_list_delete(trail_list, trail_max);
}

// 2. Movimento e Colisão com paredes
var _next_vx = vx;
var _next_vy = vy;

if (safe_timer > 0) {
    safe_timer--;
} else {
    // Ricochete horizontal
    if (tilemap_get_at_pixel(tilemap, x + vx + (vx > 0 ? 4 : -4), y) > 0) {
        vx = -vx;
    }
    // Ricochete vertical
    if (tilemap_get_at_pixel(tilemap, x, y + vy + (vy > 0 ? 4 : -4)) > 0) {
        vy = -vy;
    }
}

x += vx;
y += vy;
distance_traveled += point_distance(0, 0, vx, vy);

if (distance_traveled >= max_distance) {
    instance_destroy();
    exit;
}

// 3. Colisão com o Jogador
var _p = instance_place(x, y, obj_player);
if (_p != noone) {
    _p.hp.take_damage(x, y, _p.x, _p.y);
    instance_destroy();
}

// 4. Autodestruição por tempo (opcional para evitar bolhas infinitas)
if (x < -100 || x > room_width + 100 || y < -100 || y > room_height + 100) {
    instance_destroy();
}
