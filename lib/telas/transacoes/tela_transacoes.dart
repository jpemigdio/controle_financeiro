import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../dados/dados_iniciais.dart';
import '../../modelos/transacao.dart';
import '../../services/controle_global.dart';
import '../../widgets/cartao_resumo.dart';
import '../../telas/adicionar/tela_adicionar.dart';
import '../../tema.dart';

enum Filtro { todos, receitas, despesas }

//formator de moeda, seguindo regra brasileira: ponto no milhar e virgula nos centavos
final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
// ignore: unused_element
final _formatoData = DateFormat('dd/MM/yyyy');

class TelaTransacoes extends StatefulWidget {
  const TelaTransacoes({super.key});

  @override
  State<TelaTransacoes> createState() => _TelaTransacoesState();
}

//classe State guarda os dados e desenha a tela
class _TelaTransacoesState extends State<TelaTransacoes> {
  Filtro _filtro = Filtro.todos;
  String _busca = '';

  // Monta a lista de exibição a partir dos dados do parceiro.
  // O Gasto dele é positivo, então aqui viramos NEGATIVO (-g.valor):
  // assim o filtro e as cores (valor < 0 = despesa) continuam iguais.
  List<Transacao> get _todas {
    final lista = <Transacao>[
      for (final g in controle.gastos)
        Transacao(
          g.descricao,
          g.categoria.nome,
          -g.valor,
          iconesCategoria[g.categoria.nome] ?? Icons.category,
          g.data,
        ),
      for (final r in controle.receitas)
        Transacao(
          r.descricao,
          'Receita',
          r.valor,
          Icons.account_balance_wallet,
          r.data,
        ),
    ];

    // Mais recente primeiro. compareTo(b, a) inverte a ordem.
    lista.sort((a, b) => b.data.compareTo(a.data));
    return lista;
  }

  double get _entradas {
    final agora = DateTime.now();
    return controle.calcularReceitasPorMes(agora.month, agora.year);
  }

  double get _saidas {
    final agora = DateTime.now();
    return controle.calcularGastosPorMes(agora.month, agora.year);
  }

  List<Transacao> get _visiveis {
    return _todas.where((t) {
      final passaNoFiltro = switch (_filtro) {
        Filtro.todos => true,
        Filtro.receitas => t.valor > 0,
        Filtro.despesas => t.valor < 0,
      };
      final passaNaBusca = t.nome.toLowerCase().contains(_busca.toLowerCase());
      return passaNoFiltro && passaNaBusca;
    }).toList();
  }

  String _moeda(double v) => _formatoMoeda.format(v.abs());

  Future<void> _abrirAdicionar() async {
    await Navigator.push(
      context,
      //animação padrao de trocar de tela, builder é a função que constroi a tela que será aberta
      MaterialPageRoute(builder: (context) => const TelaAdicionar()),
    );
    if (mounted) {
      setState(() {});
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
      padding: const EdgeInsets.all(20),
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
                      color: Cores.verde,
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
          observacao: '${controle.receitas.length} receita(s)',
          cor: Colors.green.shade800,
          corFundo: Colors.green.shade50,
        ),
        CartaoResumo(
          icone: Icons.arrow_upward,
          titulo: 'Saídas no mês',
          valor: _moeda(_saidas),
          observacao: '${controle.gastos.length} despesa(s)',
          cor: Colors.red.shade800,
          corFundo: Colors.red.shade50,
        ),
        CartaoResumo(
          icone: Icons.swap_horiz,
          titulo: 'Total de lançamentos',
          valor: '${_todas.length}',
          observacao: 'transações registradas',
          cor: Colors.indigo.shade700,
          corFundo: Colors.indigo.shade50,
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
