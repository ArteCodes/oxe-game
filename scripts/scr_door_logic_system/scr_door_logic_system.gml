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
	        var _active1 = false;
	        var _active2 = true; // Assume verdadeiro por padrão se não houver segundo botão
	        
	        if (instance_exists(btn1)) {
	            if (variable_instance_exists(btn1, "button_logic") && btn1.button_logic != undefined) {
	                _active1 = btn1.button_logic.is_active;
	            } else if (variable_instance_exists(btn1, "is_active")) {
	                _active1 = btn1.is_active;
	            }
	        }
	        if (btn2 != noone && btn2 != undefined && instance_exists(btn2)) {
	            if (variable_instance_exists(btn2, "button_logic") && btn2.button_logic != undefined) {
	                _active2 = btn2.button_logic.is_active;
	            } else if (variable_instance_exists(btn2, "is_active")) {
	                _active2 = btn2.is_active;
	            }
	        }
	        
	        if (_active1 && _active2) {
	            is_opening = true;
	            _inst.sprite_index = spr_ani;
	            _inst.image_index = 0;
	            _inst.image_speed = 0.5; // Garante que a animação rode e destrua a porta no final

	            // Limpa colisão temporária no player
	            if (instance_exists(obj_player)) {
	                obj_player.collision_temp_1 = undefined;
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