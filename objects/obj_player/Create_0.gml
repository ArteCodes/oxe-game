// Sistemas de movimento
movement  = new MovementSystem(4, 0.8, 0.18);   // velocidade, aceleração, fricção
dodge     = new DodgeSystem(200, 20, 36);        // distância, duração, cooldown
collision = new CollisionSystem("Tiles_Wall", 16, 16); // colisão com tiles

// Sistemas de combate
ball      = new BallSystem();          // gerencia estado da bolinha
slingshot = new SlingshotSystem(ball); // gerencia carregamento e disparo
slingshot.owner_ref = id;             // passa referência do player para o estilingue

// Sistemas de mira
aim = new AimSystem("Tiles_Wall"); // simula e desenha a trajetória da bolinha

// Garante que o player é desenhado acima dos tiles
depth = -100;