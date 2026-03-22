// Destroi o sistema de particulas e o inimigo
if (variable_instance_exists(id, "part_system_ref")) {
    part_system_destroy(part_system_ref);
}
instance_destroy();