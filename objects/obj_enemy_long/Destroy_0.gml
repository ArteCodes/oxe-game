// --- Evento Destruir (Destroy) do obj_enemy_long ---
// Quando o caranguejo azul (long-range) é destruído, cria a animação de morte dele com a mesma explosão branca pequena do normal!
if (sprite_exists(spr_crab_blue_death)) {
    var _death = safe_create_layer(x, y, "Instances", obj_enemy_death);
    if (instance_exists(_death)) {
        _death.sprite_index = spr_crab_blue_death;
    }
}



