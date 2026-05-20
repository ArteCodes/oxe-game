// --- Evento Passo (Step) ---

// 1. Redução do cooldown de dano e feedback visual (pisca transparência como o player)
if (variable_instance_exists(self, "hit_cooldown") && hit_cooldown > 0) {
    hit_cooldown--;
    image_alpha = (hit_cooldown mod 6 < 3) ? 0.3 : 1.0;
} else {
    image_alpha = 1.0;
}

// 2. Atualiza a lógica da IA
enemy_ai.update(id);

// 3. Aplica atrito
movement.apply_friction();

// 4. Resolve Colisões com o cenário
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vx = collision_meia.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);
movement.vy = collision_meia.resolve_y(x, y, movement.vy);

// 5. Aplica posição final
x += movement.vx;
y += movement.vy;
