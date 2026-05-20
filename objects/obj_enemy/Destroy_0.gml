// --- Evento Destruir (Destroy) do obj_enemy ---
// Quando o caranguejo normal é destruído (derrotado), criamos a animação de morte com explosãozinha
if (sprite_exists(spr_crab_death)) {
    instance_create_layer(x, y, "Instances", obj_enemy_death);
}
