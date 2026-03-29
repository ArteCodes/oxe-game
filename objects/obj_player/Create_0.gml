// --- Sistemas de movimento ---
movement  = new MovementSystem(4, 0.5, 0.18);
dodge     = new DodgeSystem(100, 20, 36);
collision = new CollisionSystem("Tiles_Wall", 12, 18, 12, 12);

// --- Sistemas de combate ---
ball      = new BallSystem();
slingshot = new SlingshotSystem(ball);
slingshot.owner_ref = id;
hp = new HealthSystem(3);

// --- Mira ---
aim = new AimSystem("Tiles_Wall");
aim.init(); // resolve o tilemap apos o Room estar carregado

// --- Camera ---
depth  = -100;
camera = new CameraSystem(620, 320, id);
camera.init();

// --- HUD gerenciado pelo obj_hud — nao instanciar HudSystem aqui ---

// --- Sincroniza GUI com a janela ---
var _w = display_get_width();
var _h = display_get_height();
display_set_gui_size(_w, _h);
