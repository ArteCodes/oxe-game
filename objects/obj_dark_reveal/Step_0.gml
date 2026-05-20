// --- Evento Etapa (Step) do obj_dark_reveal ---
// Verifica se o jogador está DENTRO da área escura.
// Se sim → some suavemente. Se não → reaparece suavemente.

if (instance_exists(obj_player)) {
    // Limites da zona escura (a posição x,y é o canto superior esquerdo)
    var _left   = x;
    var _top    = y;
    var _right  = x + zone_w;
    var _bottom = y + zone_h;
    
    // Verifica se o jogador está dentro do retângulo da zona
    var _inside = (obj_player.x >= _left && obj_player.x <= _right &&
                   obj_player.y >= _top  && obj_player.y <= _bottom);
    
    // Fade suave: some quando o jogador entra, reaparece quando sai
    if (_inside) {
        dark_alpha = max(0, dark_alpha - fade_speed);
    } else {
        dark_alpha = min(1, dark_alpha + fade_speed);
    }
}
