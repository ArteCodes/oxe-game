// --- Evento Limpeza (CleanUp) do obj_dark_reveal ---

// 1. Libera a superfície de escuridão da memória gráfica
if (variable_instance_exists(self, "surf_dark") && surface_exists(surf_dark)) {
    surface_free(surf_dark);
}

// 2. Destrói o grid de células reveladas
if (variable_instance_exists(self, "reveal_grid") && ds_exists(reveal_grid, ds_type_grid)) {
    ds_grid_destroy(reveal_grid);
}

// 3. Destrói o grid de áreas visitadas
if (variable_instance_exists(self, "area_visited") && ds_exists(area_visited, ds_type_grid)) {
    ds_grid_destroy(area_visited);
}
