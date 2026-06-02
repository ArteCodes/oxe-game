// --- Evento Etapa (Step) do obj_enemy_red ---

// 1. Redução do cooldown de dano e feedback visual (pisca transparência como o player)
if (variable_instance_exists(self, "hit_cooldown") && hit_cooldown > 0) {
    hit_cooldown--;
    image_alpha = (hit_cooldown mod 6 < 3) ? 0.3 : 1.0;
} else {
    image_alpha = 1.0;
}

// 2. A IA decide o que fazer e tenta aplicar o movimento
enemy_ai.update(self);

// 3. O módulo de Colisão intercepta o movimento antes que o caranguejo ande
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vx = collision_meia.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);
movement.vy = collision_meia.resolve_y(x, y, movement.vy);

// 4. Aplica o Atrito para suavizar paradas
movement.apply_friction();

// 5. Aplica as velocidades finais nas coordenadas reais da sala
x += movement.vx;
y += movement.vy;
