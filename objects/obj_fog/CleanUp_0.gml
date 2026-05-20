// --- Evento Limpeza (CleanUp) do obj_fog ---

// 1. Evita memory leaks (vazamento de memória) ao deletar o sprite procedural da VRAM
if (variable_instance_exists(self, "spr_fog_cloud") && sprite_exists(spr_fog_cloud)) {
    sprite_delete(spr_fog_cloud);
}
