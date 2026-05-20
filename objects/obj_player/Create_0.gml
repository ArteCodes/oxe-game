porta_1_aberta = false; 
window_set_fullscreen(false);
window_set_size(1280, 720);
movement  = new MovementSystem(10, 1, 0.18);   // velocidade, aceleração, fricção
dodge     = new DodgeSystem(100, 20, 36);        // distância, duração, cooldown
collision_cheia = new CollisionSystem("Tiles_Wall", 1);
collision_barrel = new CollisionSystem("Barrel", 1);
collision_meia = new CollisionSystem("Tiles_Wall_md", 2);
collision_temp_1 = new CollisionSystem("Tiles_Wall_fake", 1);

// Sistemas de combate
ball      = new BallSystem();          // gerencia estado da bolinha
slingshot = new SlingshotSystem(ball); // gerencia carregamento e disparo
slingshot.owner_ref = id;             // passa referência do player para o estilingue

hp = new HealthSystem(3);

// Sistemas de mira
aim = new AimSystem("Tiles_Wall");
// Garante que o player é desenhado acima dos tiles
depth = -100;

// Camera
camera = new CameraSystem(1100, 600, id);
camera.init();

// HUB
hud = new HudSystem(id, spr_heart_1, spr_heart_2, spr_heart_3);

// Sincroniza o tamanho do GUI com o tamanho inicial da janela (1280x720)
display_set_gui_size(1280, 720);

// --- Inicialização dos Sistemas ---
// (seus outros sistemas estarão aqui em cima)

// Inicializa o sistema de diálogos APENAS UMA VEZ
dialogo = new DialogSystem(); 

// --- Variáveis Visuais do Estilingue ---
slingshot_visual_stretch = 0;
slingshot_recoil = 0;
current_room_track = -1;

// --- Inicializa a Névoa Atmosférica (Fog) na fase ---
if (!instance_exists(obj_fog)) {
    instance_create_layer(x, y, "Instances", obj_fog);
}
