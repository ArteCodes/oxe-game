// --- 1. Delay de coleta ---
if (collect_delay > 0) collect_delay--;

// --- 2. Rastro visual ---
ds_list_add(trail, { tx: x, ty: y });
if (ds_list_size(trail) > trail_max) ds_list_delete(trail, 0);

// --- 3. Fisica (movimento, ricochete, parada) ---
physics.update(id);

// --- 4. Coleta automatica ao jogador passar por cima ---
if (collect_delay <= 0 && instance_exists(owner)) {
    if (point_distance(x, y, owner.x, owner.y) < 16) {
        owner.ball.on_ball_collected();
    }
}
