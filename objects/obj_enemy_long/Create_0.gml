 // --- Evento Criar (Create) do obj_enemy_long ---

// 1. Inicializa a IA Long (Krab Blue)
// (Velocidade: 1.5, Delay de tiro: 180 frames = 3 segundos)
enemy_ai = new EnemyLongAiSystem(1.5, 180, spr_crab_blue_idle, spr_crab_blue_run);

// 2. Sistema de Movimento
movement = new MovementSystem(2, 0.4, 0.2); 

// 3. Sistema de Colisão
collision = new CollisionSystem("Tiles_Wall", 1);
collision_meia = new CollisionSystem("Tiles_Wall_md", 2);

// 4. Garantia de Visibilidade
visible = true;
image_alpha = 1;
image_blend = c_white;
depth = -50; 

// 5. Variáveis de Mira
draw_aim = false;
aim_x = 0;
aim_y = 0;

// 6. Sistema de Vida e Cooldown de Hit
hp = 1; // O caranguejo azul (long-range) morre com 1 tiro
hit_cooldown = 0;
