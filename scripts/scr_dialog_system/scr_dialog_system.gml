/// @function DialogSystem()
/// @description Gerencia o sistema de textos e falas.
function DialogSystem() constructor {
    
    textos = [];         // Array que guardará as frases do diálogo
    linha_atual = 0;     // Índice da fala atual no Array
    ativo = false;       // Define se a caixa de texto está aparecendo na tela

    /// @function iniciar(array_de_falas)
    static iniciar = function(_array_de_falas) {
        textos = _array_de_falas; // Recebe os textos
        linha_atual = 0;          // Começa na primeira linha (índice 0)
        ativo = true;             // Liga o diálogo
    };

    /// @function proxima_linha()
    static proxima_linha = function() {
        if (ativo) {
            linha_atual++; // Avança para a próxima fala
            
            // Se passar da quantidade de falas, desliga o diálogo
            if (linha_atual >= array_length(textos)) {
                ativo = false;
            }
        }
    };

/// @function desenhar(x, y)
    static desenhar = function(_x, _y) {
        if (ativo) {
            var _texto = textos[linha_atual];
            
            // 1. Centraliza o alinhamento do texto
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            // 2. Calcula a largura e altura exatas da frase atual
            var _largura_texto = string_width(_texto);
            var _altura_texto = string_height(_texto);
            var _padding = 8; // Margem de "respiro" entre o texto e a borda da caixa
            
            // 3. Define as 4 pontas do retângulo dinâmico
            var _box_x1 = _x - (_largura_texto / 2) - _padding;
            var _box_y1 = _y - (_altura_texto / 2) - _padding;
            var _box_x2 = _x + (_largura_texto / 2) + _padding;
            var _box_y2 = _y + (_altura_texto / 2) + _padding;
            
            // 4. Desenha a caixa de fundo preta (com uma leve transparência para ficar mais bonito)
            draw_set_color(c_black);
            draw_set_alpha(0.8); 
            draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
            
            // 5. Desenha o texto branco por cima
            draw_set_color(c_white);
            draw_set_alpha(1.0);
            draw_text(_x, _y, _texto);
            
            // 6. Reseta o alinhamento de volta para o padrão! 
            // (MUITO IMPORTANTE para não entortar suas barras de vida e miras do Evento Draw)
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
   };
   
}