/// @description Sistema de transição de sala após limpar inimigos
/// @param {asset.room} _target_room Sala para onde o jogador será levado
function DoorNextSystem(_target_room) constructor {
    target_room = _target_room;
    is_unlocked = false;

    static update = function(_inst) {
        // 1. Verifica se todos os inimigos foram derrotados
        // Considera obj_enemy e obj_enemy_long (através do parent se existir)
        var _enemy_count = instance_number(obj_enemy_parent);
        
        if (_enemy_count <= 0) {
            is_unlocked = true;
            // Opcional: Mudar sprite para "aberto" aqui se quiser
        } else {
            is_unlocked = false;
        }

        // 2. Interação
        if (is_unlocked) {
            if (keyboard_check_pressed(ord("E"))) {
                if (point_distance(_inst.x, _inst.y, obj_player.x, obj_player.y) < 60) {
                    if (room_exists(target_room)) {
                        room_goto(target_room);
                    }
                }
            }
        }
    };

    static draw = function(_inst) {
        // Se estiver bloqueado, desenha um cadeado ou cor diferente
        if (!is_unlocked) {
            draw_set_color(c_red);
            draw_set_alpha(0.5);
            draw_text(_inst.x, _inst.y - 20, "Bloqueado");
            draw_set_alpha(1);
        } else {
            // Já o prompt "E" é desenhado pelo obj_player
        }
    };
}
