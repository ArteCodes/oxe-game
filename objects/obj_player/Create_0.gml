// Sistemas de movimento
movement  = new MovementSystem(4, 0.5, 0.18);
dodge     = new DodgeSystem(100, 20, 36);
collision = new CollisionSystem("Tiles_Wall", 12, 20, 12, 12);
// Sistemas de combate
ball      = new BallSystem();
slingshot = new SlingshotSystem(ball);
slingshot.owner_ref = id;
// Sistemas de mira
aim = new AimSystem("Tiles_Wall");
// Garante que o player é desenhado acima dos tiles
depth = -100;

// Camera
view_enabled = true;
view_visible[0] = true;
camera_set_view_size(view_camera[0], 480, 270);
window_set_fullscreen(true);
view_set_wport(0, display_get_width());
view_set_hport(0, display_get_height());
var _w = display_get_width();
var _h = display_get_height();
surface_resize(application_surface, _w, _h);
view_set_wport(0, _w);
view_set_hport(0, _h);