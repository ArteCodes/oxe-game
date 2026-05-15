// --- Evento Etapa (Step) do obj_enemy ---

// 1. A IA decide o que fazer e tenta aplicar o movimento (ex: chama movement.move())
enemy_ai.update(self); 

// 2. O módulo de Colisão intercepta o movimento antes que o caranguejo ande
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// 3. Aplica o Atrito para suavizar paradas
movement.apply_friction();

// 4. Aplica as velocidades finais nas coordenadas reais da sala
x += movement.vx;
y += movement.vy;