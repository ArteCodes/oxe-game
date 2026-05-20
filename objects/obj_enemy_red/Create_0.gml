// --- Evento Criar (Create) do obj_enemy_red ---

// 1. Inicializa a IA do Caranguejo Vermelho (Perseguidor Melee Agressivo)
// Velocidade: 2.5 (mais rápido que o normal!)
enemy_ai = new EnemyRedAiSystem(2.5, spr_crab_red_idle, spr_crab_red_run, spr_crab_red_attack);

// 2. Sistema de Movimento (Mais veloz que o normal)
// (Velocidade Máxima: 4, Aceleração: 0.6, Atrito: 0.2)
movement = new MovementSystem(4, 0.6, 0.2); 

// 3. Sistema de Colisão
collision = new CollisionSystem("Tiles_Wall", 1);

// 4. Garantia de Visibilidade
visible = true;
image_alpha = 1;
image_blend = c_white;
depth = -50;

// 5. Sistema de Vida e Cooldown de Hit
hp = 3; // O caranguejo vermelho morre com 3 tiros!
hit_cooldown = 0;
