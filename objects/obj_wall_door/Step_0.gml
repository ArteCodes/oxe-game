// --- Evento Etapa (Step) do obj_wall_door ---
if (door_sys == undefined) {
    // Busca automática por proximidade se btn1 não foi definido na Creation Code do editor de salas
    if (btn1 == noone) {
        var _nearest_btn = instance_nearest(x, y, obj_button);
        var _nearest_rev = instance_nearest(x, y, obj_button_reverse);
        var _nearest_sto = instance_nearest(x, y, obj_stone_button);
        
        var _dist_btn = _nearest_btn != noone ? point_distance(x, y, _nearest_btn.x, _nearest_btn.y) : 999999;
        var _dist_rev = _nearest_rev != noone ? point_distance(x, y, _nearest_rev.x, _nearest_rev.y) : 999999;
        var _dist_sto = _nearest_sto != noone ? point_distance(x, y, _nearest_sto.x, _nearest_sto.y) : 999999;
        
        var _min_dist = min(_dist_btn, _dist_rev, _dist_sto);
        
        if (_min_dist < 999999) {
            if (_min_dist == _dist_btn) {
                btn1 = _nearest_btn;
            } else if (_min_dist == _dist_rev) {
                btn1 = _nearest_rev;
            } else {
                btn1 = _nearest_sto;
            }
        }
    }

    // Inicializa a lógica se o botão primário for válido
    if (btn1 != noone && instance_exists(btn1)) {
        door_sys = new DoorLogic(btn1, btn2, compl_Wall_Door_ani);
    }
} else {
    door_sys.update(self);
}