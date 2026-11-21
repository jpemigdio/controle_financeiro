import 'package:flutter/material.dart';

import '../../dados/dados_exemplo.dart';
import '../../modelos/transacao.dart';
import '../../widgets/cartao_resumo.dart';

enum Filtro { todos, receitas, despesas }

class TelaTransacoes extends StatefulWidget {
  const TelaTransacoes({super.key});

  @override
  State<TelaTransacoes> createState() => _TelaTransacoesState();
}

class _TelaTransacoesState extends State<TelaTransacoes> {
  Filtro _filtro = Filtro.todos;
  String _busca = '';

  List<Transacao> get _visiveis {
    return transacoes.where((t) {
      final passaNoFiltro = switch (_filtro) {
        Filtro.todos => true,
        Filtro.receitas => t.valor > 0,
        Filtro.despesas => t.valor < 0,
      };
      final passaNaBusca = t.nome.toLowerCase().contains(_busca.toLowerCase());
      return passaNoFiltro && passaNaBusca;
    }).toList();
  }

  String _moeda(double v) {
    return 'R\$ ${v.abs().toStringAsFixed(2).replaceAll('.', ',')}';
  }

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
        Text('VISÃO GERAL', style: textos.bodySmall),
        Text('Transações', style: textos.headlineSmall),
        const SizedBox(height: 16),
        const CartaoResumo(
          icone: Icons.arrow_downward,
          titulo: 'Entrada do mês',
          valor: 'R\$ 7.450,00',
          observacao: '+12,5% neste mês',
          cor: Color(0xFF0F7B6C),
          corFundo: Color(0xFFE3F3EF),
          corObservacao: Color(0xFF0F7B6C),
        ),
        const CartaoResumo(
          icone: Icons.arrow_upward,
          titulo: 'Saídas no mês',
          valor: 'R\$ 3.168,40',
          observacao: '3,2% a menos',
          cor: Color(0xFFB71C1C),
          corFundo: Color(0xFFFDEDE7),
          corObservacao: Color(0xFFB71C1C),
        ),
        const CartaoResumo(
          icone: Icons.swap_horiz,
          titulo: 'Total de lançamentos',
          valor: '32',
          observacao: '8 pendentes',
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
