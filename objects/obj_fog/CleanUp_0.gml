// --- Evento Limpeza (CleanUp) do obj_fog ---

// 1. Evita memory leaks (vazamento de memória) ao deletar o sprite procedural da VRAM
if (variable_instance_exists(self, "spr_fog_cloud") && sprite_exists(spr_fog_cloud)) {
    sprite_delete(spr_fog_cloud);
}

// 2. Libera a superfície do Fog de Guerra para evitar vazamento de memória gráfica
if (variable_instance_exists(self, "surf_fog") && surface_exists(surf_fog)) {
    surface_free(surf_fog);
}
