// --- Evento Etapa (Step) do obj_door_next ---

// 1. DETECÇÃO: Rastreia se inimigos existem na sala antes de poder abrir
if (!enemies_detected) {
    if (instance_number(obj_enemy_parent) > 0) {
        enemies_detected = true;
    }
}

// 2. ABERTURA DO PORTAL — só abre se os inimigos foram detectados e depois eliminados
var _enemies_cleared = enemies_detected && (instance_number(obj_enemy_parent) <= 0);

if (_enemies_cleared && !portal_active && !portal_opening) {
    portal_opening = true;
    visible = true;
    // Efeito de partículas de impacto ao abrir
    effect_create_above(ef_ring, x, y, 1.5, make_color_rgb(80, 180, 255));
    effect_create_above(ef_spark, x, y, 2, make_color_rgb(120, 80, 255));
    effect_create_above(ef_spark, x, y, 1, make_color_rgb(200, 120, 255));
}

// 3. ANIMAÇÃO DE ABERTURA (escala cresce suavemente de 0 a 1)
if (portal_opening) {
    portal_scale = min(portal_scale + 0.04, 1.0);
    portal_alpha = min(portal_alpha + 0.05, 1.0);
    if (portal_scale >= 1.0) {
        portal_opening = false;
        portal_active = true;
    }
}

// 4. PORTAL ATIVO — animação contínua e detecção de entrada
if (portal_active) {
    // Rotação do anel externo
    portal_angle += 2;
    if (portal_angle >= 360) portal_angle -= 360;
    
    // Pulsação interna
    portal_pulse += 0.08;
    
    // Gera partículas flutuantes ao redor do portal
    if (irandom(3) == 0) {
        var _a = random(360);
        var _r = 20 + random(10);
        array_push(portal_particles, {
            px: x + lengthdir_x(_r, _a),
            py: y + lengthdir_y(_r, _a),
            pvx: lengthdir_x(0.3, _a + 90),
            pvy: lengthdir_y(0.3, _a + 90) - 0.5,
            palpha: 0.8,
            pscale: 0.5 + random(0.5)
        });
    }
    
    // Teleporta o jogador ao entrar no portal
    if (instance_exists(obj_player)) {
        if (point_distance(x, y, obj_player.x, obj_player.y) < 24) {
            // Inicia fechamento
            portal_closing = true;
            portal_active = false;
            // Efeito de absorção
            effect_create_above(ef_ring, x, y, 1, make_color_rgb(200, 120, 255));
        }
    }
}

// 5. ANIMAÇÃO DE FECHAMENTO e transição de sala
if (portal_closing) {
    portal_scale = max(portal_scale - 0.06, 0);
    portal_alpha = max(portal_alpha - 0.08, 0);
    if (portal_scale <= 0) {
        portal_closing = false;
        if (room_exists(target_room)) {
            room_goto(target_room);
        }
    }
}

// 6. ATUALIZAÇÃO DAS PARTÍCULAS
for (var _i = array_length(portal_particles) - 1; _i >= 0; _i--) {
    var _p = portal_particles[_i];
    _p.px += _p.pvx;
    _p.py += _p.pvy;
    _p.palpha -= 0.02;
    if (_p.palpha <= 0) {
        array_delete(portal_particles, _i, 1);
    }
}

// Se há inimigos vivos, o portal permanece invisível
if (!_enemies_cleared && !portal_opening && !portal_active && !portal_closing) {
    visible = false;
}
