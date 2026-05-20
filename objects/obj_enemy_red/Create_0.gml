// --- Evento Criar (Create) do obj_enemy_red ---

// 1. Inicializa a IA do caranguejo vermelho com o mesmo tipo de comportamento do inimigo normal
enemy_ai = new EnemyRedAiSystem(4, 18, spr_crab_red_idle, spr_crab_red_run, spr_crab_red_attack);

// 2. Inicializa o sistema de movimento igual ao inimigo normal
// (Velocidade Máxima: 4, Aceleração: 0.5, Atrito: 0.2)
movement = new MovementSystem(4, 0.5, 0.2);

// 3. Inicializa o sistema de colisão igual ao inimigo normal
collision = new CollisionSystem("Tiles_Wall", 1);
collision_meia = new CollisionSystem("Tiles_Wall_md", 2);

// 4. Garantia de Visibilidade
visible = true;
image_alpha = 1;
image_blend = c_white;
depth = -50;

// 5. Sistema de Vida e Cooldown de Hit
hp = 3; // O caranguejo vermelho agora tem 3 vidas
hit_cooldown = 0;
