// Instancia os sistemas do personagem
movement  = new MovementSystem(4, 0.8, 0.18);
dodge     = new DodgeSystem(96, 12, 36);
collision = new CollisionSystem("Tiles_Wall", 16, 16);
ball = new BallSystem();