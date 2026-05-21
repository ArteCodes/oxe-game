// --- Evento Destruir (Destroy) do obj_enemy_red ---
// Quando o caranguejo vermelho é destruído, cria a animação de morte com a explosão branca
if (sprite_exists(spr_crab_red_death)) {
    var _death = safe_create_layer(x, y, "Instances", obj_enemy_death);
    if (instance_exists(_death)) {
        _death.sprite_index = spr_crab_red_death;
    }
}



