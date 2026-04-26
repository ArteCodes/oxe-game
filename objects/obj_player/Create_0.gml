// --- Sistemas de movimento ---
movement  = new MovementSystem(4, 0.5, 0.18);
dodge     = new DodgeSystem(100, 20, 36);
collision = new CollisionSystem(["Tiles_Wall", "Tiles_Wall_1"], 10, 10, 10, 12);

// --- Sistemas de combate ---
ball      = new BallSystem();
slingshot = new SlingshotSystem(ball);
slingshot.owner_ref = id;
hp        = new HealthSystem(3);

// --- Inventario de pedras ---
inventory = new InventorySystem(3); // maximo de 3 pedras no bolso

// --- Mira ---
aim = new AimSystem("Tiles_Wall");
aim.init(); // resolve o tilemap apos o Room estar carregado

// --- Camera ---
depth  = -100;
camera = new CameraSystem(620, 320, id);
camera.init();

// --- HUD gerenciado pelo obj_hud ---

// --- Sincroniza GUI com a janela ---
var _w = display_get_width();
var _h = display_get_height();
display_set_gui_size(_w, _h);
