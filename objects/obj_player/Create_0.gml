// Instancia os sistemas do personagem
movement  = new MovementSystem(4, 0.8, 0.18);
dodge     = new DodgeSystem(200, 20, 36);
collision = new CollisionSystem("Tiles_Wall", 16, 16);
aim = new AimSystem("Tiles_Wall");
ball      = new BallSystem();
slingshot = new SlingshotSystem(ball);
slingshot.owner_ref = id;
depth = -100;