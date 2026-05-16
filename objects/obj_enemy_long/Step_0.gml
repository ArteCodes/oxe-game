// --- Evento Passo (Step) ---

// 1. Atualiza a lógica da IA
enemy_ai.update(id);

// 2. Aplica atrito
movement.apply_friction();

// 3. Resolve Colisões com o cenário
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// 4. Aplica posição final
x += movement.vx;
y += movement.vy;
