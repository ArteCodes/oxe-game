// Verifica se todos os inimigos foram derrotados
// obj_enemy_parent cobre tanto o caranguejo normal quanto o azul
if (instance_number(obj_enemy_parent) <= 0) {
    visible = true;
} else {
    visible = false;
}
