import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dados/dados_exemplo.dart';
import '../../modelos/transacao.dart';
import '../../widgets/cartao_resumo.dart';
import '../../telas/adicionar/tela_adicionar.dart';

enum Filtro { todos, receitas, despesas }

//formator de moeda, seguindo regra brasileira: ponto no milhar e virgula nos centavos
final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class TelaTransacoes extends StatefulWidget {
  const TelaTransacoes({super.key});

  @override
  State<TelaTransacoes> createState() => _TelaTransacoesState();
}

//classe State guarda os dados e desenha a tela
class _TelaTransacoesState extends State<TelaTransacoes> {
  Filtro _filtro = Filtro.todos;
  String _busca = '';

  //entrada: soma dos valores positivos
  double get _entradas => transacoes
      .where((t) => t.valor > 0)
      .fold(0.0, (soma, t) => soma + t.valor);

  //saida: soma dos valores negativos
  double get _saidas => transacoes
      .where((t) => t.valor < 0)
      .fold(0.0, (soma, t) => soma + t.valor.abs());

  //.length mostra quantos itens sobraram depois do filtro
  int get _qtdReceitas => transacoes.where((t) => t.valor > 0).length;
  int get _qtdDespesas => transacoes.where((t) => t.valor < 0).length;

  List<Transacao> get _visiveis {
    return transacoes.where((t) {
      final passaNoFiltro = switch (_filtro) {
        Filtro.todos => true,
        Filtro.receitas => t.valor > 0,
        Filtro.despesas => t.valor < 0,
      };
      final passaNaBusca = t.nome.toLowerCase().contains(_busca.toLowerCase());
      //O item só aparece se passar nas duas condiçoes
      return passaNoFiltro && passaNaBusca;
    }).toList();
  }

  String _moeda(double v) => _formatoMoeda.format(v.abs());

  Future<void> _abrirAdicionar() async {
    final nova = await Navigator.push<Transacao>(
      context,
      //animação padrao de trocar de tela, builder é a função que constroi a tela que será aberta
      MaterialPageRoute(builder: (context) => const TelaAdicionar()),
    );
    if (nova != null && mounted) {
      setState(() {
        transacoes.insert(0, nova); //insert 0 coloca no INICIO da lista
      });
    }
  }

  //Monta uma linha da lista. Fica dentro de uma lista de widgets, nao da para declarar variavéis
  Widget _linha(Transacao t) {
    final ehDespesa = t.valor < 0;
    final cor = ehDespesa ? Colors.red.shade600 : Colors.green.shade700;
    final sinal = ehDespesa ? '-' : '+';

    return ListTile(
      leading: CircleAvatar(child: Icon(t.icone)),
      title: Text(t.nome),
      subtitle: Text(t.categoria),
      trailing: Text(
        '$sinal ${_moeda(t.valor)}',
        style: TextStyle(fontWeight: FontWeight.w600, color: cor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        //Cabecalho com o botao + (Row é lado a lado)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VISÃO GERAL',
                    style: textos.labelSmall?.copyWith(
                      //copywith pega o estilo do tema e muda só o que voce pedir
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F7B6C),
                    ),
                  ),
                  Text(
                    'Transações',
                    style: textos.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Acompanhe e organize suas finanças em um só lugar',
                    style: textos.bodySmall,
                  ),
                ],
              ),
            ),
            //IconButton.filled = botao só com icone e fundo colorido
            IconButton.filled(
              //sem parenteses porque entrega a função para o botao chamar
              //quando for tocad. Com () ela rodaria ao desenhar a tela
              onPressed: _abrirAdicionar,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // sem const porque os valores sao calculados e mudam
        CartaoResumo(
          icone: Icons.arrow_downward,
          titulo: 'Entrada do mês',
          valor: _moeda(_entradas),
          observacao: '$_qtdReceitas receita(s)',
          cor: Color(0xFF0F7B6C),
          corFundo: Color(0xFFE3F3EF),
          corObservacao: Color(0xFF0F7B6C),
        ),
        CartaoResumo(
          icone: Icons.arrow_upward,
          titulo: 'Saídas no mês',
          valor: _moeda(_saidas),
          observacao: '$_qtdDespesas despesa(s)',
          cor: Color(0xFFB71C1C),
          corFundo: Color(0xFFFDEDE7),
          corObservacao: Color(0xFFB71C1C),
        ),
        CartaoResumo(
          icone: Icons.swap_horiz,
          titulo: 'Total de lançamentos',
          valor: '${transacoes.length}',
          observacao: 'transações registradas',
          cor: Color(0xFF3F51B5),
          corFundo: Color(0xFFEEF0FD),
          corObservacao: Color(0xFF3F51B5),
        ),
        const SizedBox(height: 16),

        SegmentedButton<Filtro>(
          segments: const [
            ButtonSegment(value: Filtro.todos, label: Text('Todos')),
            ButtonSegment(value: Filtro.receitas, label: Text('Receitas')),
            ButtonSegment(value: Filtro.despesas, label: Text('Despesas')),
          ],
          selected: {_filtro},
          onSelectionChanged: (Set<Filtro> escolhido) {
            setState(() {
              _filtro = escolhido.first;
            });
          },
        ),
        const SizedBox(height: 12),

        TextField(
          onChanged: (String texto) {
            setState(() {
              _busca = texto;
            });
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Buscar transação',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        for (final t in _visiveis) _linha(t),
      ],
    );
  }
}
