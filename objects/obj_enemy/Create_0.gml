// --- Evento Criar (Create) do obj_enemy ---

// 1. Inicializa a Inteligência Artificial do Inimigo
// O primeiro valor é a velocidade de seguir e o segundo é a velocidade da investida
enemy_ai = new EnemyAiSystem(2, 12, spr_crab_idle, spr_crab_run);

// 2. Inicializa o sistema de movimento exclusivo do inimigo
// (Velocidade Máxima: 3, Aceleração: 0.5, Atrito: 0.2)
movement = new MovementSystem(3, 0.5, 0.2); 

// 3. Inicializa o sistema de colisão informando o nome da camada de tiles
collision = new CollisionSystem("Tiles_Wall", 1);

// 4. Garantia de Visibilidade
visible = true;
image_alpha = 1;
image_blend = c_white;
depth = -50; // Garante que fique acima do chão