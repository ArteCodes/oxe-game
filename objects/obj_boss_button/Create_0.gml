// --- Evento Criar (Create) do obj_boss_button ---
visible = false; // Começa invisível na parede
boss_detected = false; // Rastreia se o boss foi avistado na sala

button_logic = new ButtonLogic(spr_button_off, spr_button_on);
image_blend = make_color_rgb(255, 30, 70); // Tonalidade rubi/carmesim exclusiva
