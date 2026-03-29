// Velocidade — sobrescrita pelo SlingshotSystem ao disparar
vx = 0;
vy = 0;

// Parametros de voo — sobrescritos pelo SlingshotSystem
initial_speed     = 8;
max_distance      = 400;
distance_traveled = 0;

// Coleta
collect_delay = 20; // frames antes de poder ser coletada (evita coleta instantanea)
owner         = noone;

// Rastro visual
trail     = ds_list_create();
trail_max = 10;

// Sistema de fisica — resolve o tilemap via init()
physics = new BallPhysicsSystem("Tiles_Wall");
physics.init();
