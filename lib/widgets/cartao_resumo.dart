import 'package:flutter/material.dart';

class CartaoResumo extends StatelessWidget {
  //widget "sem estado", ele só mostra o que recebe (no caso do card)

  //Construtor
  const CartaoResumo({
    //as chaves fazem os parametros serem nomeados
    super.key,
    required this.icone, //required é o obrigatório, se voce esquecer o dart avisa o erro
    required this.titulo,
    required this.valor,
    required this.observacao,
    required this.cor,
    required this.corFundo,
    this.corObservacao, //esse parametro é opcional
  });

  //Campos: guarda o que o construtor recebeu
  final IconData icone; //final o valor é definido uma vez e nao muda
  final String titulo;
  final String valor;
  final String observacao;
  final Color cor; //cor forte do icone e textos
  final Color corFundo; // cor suave do fundo do card
  final Color? corObservacao; // o ? significa que "pode ser null", se for usa a mesma cor do icone

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context)
        .textTheme; //pega os estilos de texto do tema do app

    //Mesmo estilo dos cards da inicio
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        //coloca os filhos lado a lado (horizontal): [icone] [espaco] [textos]
        children: [
          Container(
            //caixa que aceita tamanho, cor e formato
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.15), //cor que veio do parametro
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: cor, size: 20),
          ),
          const SizedBox(width: 16), //espaco vazio de 16px de largura
          Column(
            //empilha os filhos na vertical
            crossAxisAlignment:
                CrossAxisAlignment.start, //alinha os textos pela esquerda
            children: [
              Text(titulo, style: textos.bodyMedium),
              const SizedBox(height: 2),
              Text(
                valor,
                style: textos.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                observacao,
                style: textos.labelSmall?.copyWith(color: corObservacao),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
