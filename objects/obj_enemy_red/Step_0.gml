// --- Evento Etapa (Step) do obj_enemy_red ---

// 1. Redução do cooldown de dano e feedback visual (pisca transparência como o player)
if (variable_instance_exists(self, "hit_cooldown") && hit_cooldown > 0) {
    hit_cooldown--;
    image_alpha = (hit_cooldown mod 6 < 3) ? 0.3 : 1.0;
} else if (enemy_ai == undefined || enemy_ai.state != "exploding") {
    image_alpha = 1.0;
}

// 2. A IA decide o que fazer e seta movement.vx / movement.vy
enemy_ai.update(self); 

// 3. O módulo de Colisão intercepta o movimento antes de andar
movement.vx = collision.resolve_x(x, y, movement.vx);
movement.vy = collision.resolve_y(x, y, movement.vy);

// 4. Aplica as velocidades finais nas coordenadas reais
x += movement.vx;
y += movement.vy;

// 5. Aplica o Atrito APÓS mover (para não comer a velocidade da IA)
movement.apply_friction();
