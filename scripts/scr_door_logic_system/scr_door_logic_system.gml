/// @description Lógica modular para portas que abrem com dois botões
/// @param {id} _btn1 ID da instância do primeiro botão
/// @param {id} _btn2 ID da instância do segundo botão
/// @param {asset} _spr_ani Sprite da animação de abertura
function DoorLogic(_btn1, _btn2, _spr_ani) constructor {
    btn1 = _btn1;
    btn2 = _btn2;
    spr_ani = _spr_ani;
    is_opening = false;

	static update = function(_inst) {
	    if (!is_opening) {
	        if (instance_exists(btn1) && instance_exists(btn2)) {
	            if (btn1.button_logic.is_active && btn2.button_logic.is_active) {
	                is_opening = true;
	                _inst.sprite_index = spr_ani;
	                _inst.image_index = 0;

	                // Usamos a notação de ponto para acessar a variável no player [1]
	                if (instance_exists(obj_player)) {
	                    obj_player.collision_temp_1 = undefined;
	                }
	            }
	        }
	    } 
	    else {
	        if (_inst.image_index >= _inst.image_number - 1) {
	            with (_inst) {
	                instance_destroy(); 
	            }
	        }
	    }
	}
}