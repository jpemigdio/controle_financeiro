import 'package:flutter/material.dart';

class CartaoResumo extends StatelessWidget { //widget "sem estado", ele só mostra o que recebe (no caso do card)
  
  //Construtor
  const CartaoResumo({ //as chaves fazem os parametros serem nomeados
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
  final IconData icone;  //final o valor é definido uma vez e nao muda
  final String titulo;
  final String valor;
  final String observacao;
  final Color cor;
  final Color corFundo;
  final Color? corObservacao; // o ? significa que "pode ser null"

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme; //pega os estilos de texto do tema do app

    return Card( //Card é a caixa que envolve o conteudo
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12), //espaco entre um card e outro
      shape: RoundedRectangleBorder( //define o formato do card: cantos arredondados e borda
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE8EEEC)),
      ),
      child: Padding( //espaço interno entre a borda do card e o conteudo
        padding: const EdgeInsets.all(20),

        child: Row( //coloca os filhos lado a lado (horizontal): [icone] [espaco] [textos]
          children: [
            Container( //caixa que aceita tamanho, cor e formato
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: corFundo, //cor que veio do parametro
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icone, color: cor),
            ),
            const SizedBox(width: 16), //espaco vazio de 16px de largura
            Column( //empilha os filhos na vertical
              crossAxisAlignment: CrossAxisAlignment.start, //alinha os textos pela esquerda
              children: [
                Text(titulo, style: textos.bodySmall),
                Text(valor, style: textos.titleLarge),
                Text(
                  observacao,
                  style: textos.labelSmall?.copyWith(color: corObservacao),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
