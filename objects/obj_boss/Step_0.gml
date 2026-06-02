// --- Evento Etapa (Step) do obj_boss ---

// 1. Redução do cooldown de dano e feedback visual (pisca transparência quando atingido)
if (variable_instance_exists(self, "hit_cooldown") && hit_cooldown > 0) {
    hit_cooldown--;
    image_alpha = (hit_cooldown mod 6 < 3) ? 0.35 : 1.0;
} else {
    image_alpha = 1.0;
}

// 2. A IA exclusiva do Boss decide sua ação e atualiza o estado/posição
enemy_ai.update(self);

// 3. O módulo de colisão bloqueia o movimento contra paredes cheias e meias
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vx = collision_meia.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);
movement.vy = collision_meia.resolve_y(x, y, movement.vy);

// 4. Aplica atrito para amortecer paradas ou após a investida do dash
movement.apply_friction();

// 5. Soma a velocidade física às coordenadas reais do Boss na sala
x += movement.vx;
y += movement.vy;
