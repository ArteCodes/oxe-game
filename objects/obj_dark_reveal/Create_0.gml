// --- Evento Criar (Create) do obj_dark_reveal ---
// Objeto que você COLOCA no editor de sala para cobrir uma área com escuridão.
// Quando o jogador entra → a escuridão some suavemente.
// Quando o jogador sai → a escuridão reaparece suavemente.

// Profundidade: desenha acima do player e inimigos
depth = -130;

// Tamanho da zona escura em pixels (pode mudar no editor de sala via propriedades do objeto)
// zone_w e zone_h são definidos como propriedades do objeto no .yy
// Valor padrão caso não seja definido pelo editor:
if (!variable_instance_exists(self, "zone_w")) zone_w = 500;
if (!variable_instance_exists(self, "zone_h")) zone_h = 500;

// Estado visual
dark_alpha = 1.0;    // 1.0 = totalmente escuro, 0.0 = totalmente revelado
fade_speed = 0.04;   // Velocidade de transição suave do fade
