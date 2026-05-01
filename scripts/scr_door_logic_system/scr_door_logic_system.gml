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
        // 1. Verificação dos Botões (Teoria da Notação de Ponto) [4]
        if (!is_opening) {
            if (instance_exists(btn1) && instance_exists(btn2)) {
                // Acessa a struct "button_logic" dentro de cada botão
                if (btn1.button_logic.is_active && btn2.button_logic.is_active) {
                    is_opening = true;
                    _inst.sprite_index = spr_ani;
                    _inst.image_index = 0; // Inicia a animação do começo [5, 6]
                }
            }
        } 
        // 2. Verificação do Fim da Animação
        else {
            // Se o quadro atual for o último ou maior que o total de quadros [5]
            if (_inst.image_index >= _inst.image_number - 1) {
                with (_inst) {
                    instance_destroy(); // Deleta o objeto para liberar a passagem [7]
                }
            }
        }
    }
}