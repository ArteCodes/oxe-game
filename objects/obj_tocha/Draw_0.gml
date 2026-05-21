// --- Evento Draw da Tocha ---

// 1. Desenha o brilho quente pulsante da chama (Glow Effect)
gpu_set_blendmode(bm_add);
var _pulse = 1.0 + sin(current_time * 0.006) * 0.06;
draw_sprite_ext(sprite_index, image_index, x, y, _pulse * 1.6, _pulse * 1.6, 0, c_orange, 0.25);
gpu_set_blendmode(bm_normal);

// 2. Desenha a tocha em si
draw_self();
