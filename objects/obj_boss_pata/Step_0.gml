// Lógica da pata do boss (surgindo do chão)
// Causa dano no jogador quando a pata emerge
if (!has_damaged && image_index >= 1) {
    if (instance_exists(obj_player)) {
        var _real_dist = point_distance(x, y, obj_player.x, obj_player.y);
        
        // Aumenta o raio de colisão para 75px devido ao tamanho maior da garra (1.8x)
        if (_real_dist <= 75) {
            obj_player.hp.take_damage(x, y, obj_player.x, obj_player.y);
            
            // Efeito visual premium de acerto
            effect_create_above(ef_ring, x, y, 0, c_red);
        }
    }
    has_damaged = true;
}

// Se a animação terminou, a pata volta para baixo e se destrói
if (image_index >= image_number - 1) {
    // Efeito de poeira ao sumir
    effect_create_above(ef_smoke, x, y, 0, c_gray);
    instance_destroy();
}

