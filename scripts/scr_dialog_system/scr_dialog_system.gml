/// @function DialogSystem()
/// @description Gerencia o sistema de textos e falas.
function DialogSystem() constructor {
    
    textos = [];         
    linha_atual = 0;     
    ativo = false;       
    caracteres_exibidos = 0; // NOVA: Controla o efeito máquina de escrever

    /// @function iniciar(array_de_falas)
    static iniciar = function(_array_de_falas) {
        textos = _array_de_falas; 
        linha_atual = 0;          
        caracteres_exibidos = 0;  // Zera as letras
        ativo = true;             
    };
    
    /// @function atualizar()
    // Processa a lógica do efeito a cada quadro [1]
    static atualizar = function() {
        if (ativo) {
            var _tamanho_total = string_length(textos[linha_atual]);
            if (caracteres_exibidos < _tamanho_total) {
                caracteres_exibidos += 0.5; // VELOCIDADE: Aumente para ficar mais rápido, diminua para mais devagar
            }
        }
    };

    /// @function proxima_linha()
    static proxima_linha = function() {
        if (ativo) {
            var _tamanho_total = string_length(textos[linha_atual]);
            
            // Se o texto ainda está sendo digitado, aperta "E" para terminar instantaneamente!
            if (caracteres_exibidos < _tamanho_total) {
                caracteres_exibidos = _tamanho_total;
            } 
            // Se já terminou de digitar, avança para a próxima frase
            else {
                linha_atual++; 
                caracteres_exibidos = 0; // Zera para a nova frase
                
                if (linha_atual >= array_length(textos)) {
                    ativo = false;
                }
            }
        }
    };

    /// @function desenhar(x, y)
    static desenhar = function(_x, _y) {
        if (ativo) {
            var _texto_completo = textos[linha_atual];
            // Corta a String para mostrar apenas o que já foi digitado
            var _texto_parcial = string_copy(_texto_completo, 1, floor(caracteres_exibidos));
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            // Usamos o tamanho do texto COMPLETO para calcular a caixa preta. 
            // Assim ela não fica crescendo esquisito enquanto o texto aparece!
            var _largura_texto = string_width(_texto_completo);
            var _altura_texto = string_height(_texto_completo);
            var _padding = 8; 
            
            var _box_x1 = _x - (_largura_texto / 2) - _padding;
            var _box_y1 = _y - (_altura_texto / 2) - _padding;
            var _box_x2 = _x + (_largura_texto / 2) + _padding;
            var _box_y2 = _y + (_altura_texto / 2) + _padding;
            
            draw_set_color(c_black);
            draw_set_alpha(0.8); 
            draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
            
            draw_set_color(c_white);
            draw_set_alpha(1.0);
            // Desenha a versão cortada (efeito máquina de escrever)
            draw_text(_x, _y, _texto_parcial);
            
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
   }; 
}