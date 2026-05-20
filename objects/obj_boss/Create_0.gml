// --- Evento Criar (Create) do obj_boss ---

// 1. Inicializa a Inteligência Artificial exclusiva do Boss
// (Velocidade normal de perseguição: 1.2, Velocidade do Dash: 11)
enemy_ai = new EnemyBossAiSystem(1.2, 11, spr_boss_idle, spr_boss_attack);

// 2. Inicializa o sistema de movimento exclusivo
// (Velocidade Máxima: 2.5, Aceleração: 0.4, Atrito: 0.2)
movement = new MovementSystem(2.5, 0.4, 0.2);

// 3. Inicializa o sistema de colisão para as camadas de tiles do mapa
collision = new CollisionSystem("Tiles_Wall", 1);
collision_meia = new CollisionSystem("Tiles_Wall_md", 2);

// 4. Configurações visuais e profundidade
visible = true;
image_alpha = 1;
image_blend = c_white;
image_xscale = 1.8;
image_yscale = 1.8;
depth = -50; // Garante que o boss seja desenhado acima do chão

// 5. Atributos vitais exigidos
hp = 7;
hit_cooldown = 0;
