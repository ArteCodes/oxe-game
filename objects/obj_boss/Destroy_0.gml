// --- Evento Destruir (Destroy) do obj_boss ---

// 1. Explosão principal massiva no centro do Boss
effect_create_above(ef_explosion, x, y, 2, c_red);
effect_create_above(ef_ring, x, y, 2, c_white);

// 2. Reação em cadeia de explosões secundárias ao redor do corpo gigante do Boss
// Isso cria a sensação de uma destruição massiva e cataclísmica
for (var i = 0; i < 8; i++) {
    var _angle = i * 45;
    var _dist = random_range(12, 48);
    var _ex = x + lengthdir_x(_dist, _angle);
    var _ey = y + lengthdir_y(_dist, _angle);
    
    // Combina explosões comuns, fagulhas e fogos de artifício nas cores da explosão
    var _effect_type = choose(ef_explosion, ef_firework, ef_ring);
    var _color = choose(c_red, c_orange, c_yellow, c_white);
    var _size = choose(0, 1, 2);
    
    effect_create_above(_effect_type, _ex, _ey, _size, _color);
    
    // Gera nuvens de poeira e fumaça subindo da explosão
    effect_create_above(ef_smoke, _ex, _ey, choose(0, 1), c_gray);
}

// 3. Efeitos residuais de impacto de choque térmico e fumaça pesada subindo
effect_create_above(ef_ring, x, y, 1, c_orange);
effect_create_above(ef_smokeup, x, y, 2, make_color_rgb(105, 105, 105));

// 4. Criação opcional da animação de desintegração padrão como base
if (sprite_exists(spr_crab_death)) {
    safe_create_layer(x, y, "Instances", obj_enemy_death);
}

// 5. Derruba vários cajus de cura ao derrotar o chefe (100% de chance, spawna 3 cajus)
for (var i = 0; i < 3; i++) {
    var _cx = x + random_range(-32, 32);
    var _cy = y + random_range(-32, 32);
    safe_create_layer(_cx, _cy, "Instances", obj_caju);
}



