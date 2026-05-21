// --- Evento Etapa (Step) do obj_boss_wall ---
image_blend = make_color_rgb(130, 50, 50); // Mantém a matização envelhecida do boss

if (door_sys == undefined) {
    // Busca automática especificamente pelo botão exclusivo do boss
    if (btn1 == noone) {
        var _nearest_btn = instance_nearest(x, y, obj_boss_button);
        if (_nearest_btn != noone) {
            btn1 = _nearest_btn;
        }
    }

    // Inicializa a lógica se o botão exclusivo do boss for encontrado
    if (btn1 != noone && instance_exists(btn1)) {
        door_sys = new DoorLogic(btn1, btn2, compl_Wall_Door_ani);
    }
} else {
    door_sys.update(self);
}
