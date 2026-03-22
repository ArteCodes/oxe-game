// Sistemas de movimento
movement  = new MovementSystem(4, 0.5, 0.18);   // velocidade, aceleração, fricção
dodge     = new DodgeSystem(100, 20, 36);        // distância, duração, cooldown
collision = new CollisionSystem("Tiles_Wall", 12, 18, 12, 12); // colisão com tiles

// Sistemas de combate
ball      = new BallSystem();          // gerencia estado da bolinha
slingshot = new SlingshotSystem(ball); // gerencia carregamento e disparo
slingshot.owner_ref = id;             // passa referência do player para o estilingue

hp = new HealthSystem(3);

// Sistemas de mira
aim = new AimSystem("Tiles_Wall"); // simula e desenha a trajetória da bolinha

// Garante que o player é desenhado acima dos tiles
depth = -100;