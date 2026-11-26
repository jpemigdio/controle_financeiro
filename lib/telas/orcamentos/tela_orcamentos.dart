import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dados/dados_iniciais.dart'; //IconesCategoria
import '../../models/orcamento.dart';
import '../../services/controle_global.dart';
import '../../tema.dart';
import 'tela_novo_orcamento.dart';

final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class TelaOrcamentos extends StatefulWidget {
  const TelaOrcamentos({super.key});

  @override
  State<TelaOrcamentos> createState() => _TelaOrcamentosState();
}

class _TelaOrcamentosState extends State<TelaOrcamentos> {
  //Orçamento do mês atual
  List<Orcamento> get _doMes {
    final agora = DateTime.now();
    return controle.orcamentos
        .where((o) => o.mes == agora.month && o.ano == agora.year)
        .toList();
  }

  //O formulário grava direto no controle; ao voltar, redesenha a tela
  Future<void> _abrirNovo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaNovoOrcamento()),
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _remover(Orcamento o) {
    setState(() {
      controle.removerOrcamento(o);
    });
  }

  //Um card de Orçamento, usando calculos do codigo do gabriel
  Widget _item(Orcamento o) {
    final gasto = controle.calcularGastoOrcamento(o);
    final restante = controle.calcularRestanteOrcamento(o);
    final porcentagem = controle.calcularPorcentagemOrcamento(o);
    final progresso = (porcentagem / 100)
        .clamp(0.0, 1.0)
        .toDouble(); //o clamp limita entre o 0 e 1: a barra nunca passa de 100%

    final estourou = restante < 0;
    //Verde a porcentagem fica normal, laranja a partir de 80%, vermelho quando estoura (utilizado operador ternario)
    final cor = estourou
        ? Colors.red.shade700
        : (porcentagem >= 80 ? Colors.orange.shade700 : Cores.verde);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconesCategoria[o.categoria.nome] ?? Icons.category,
                  color: cor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.categoria.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Limite ${_formatoMoeda.format(o.limite)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.grey,
                ),
                tooltip: 'Remover orçamento',
                onPressed: () => _remover(o),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progresso,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.grey.shade200,
            color: cor,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gasto ${_formatoMoeda.format(gasto)}'),
              Text(
                '${porcentagem.toStringAsFixed(0)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: cor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            estourou
                ? 'Estourou em ${_formatoMoeda.format(restante.abs())}'
                : 'Disponível ${_formatoMoeda.format(restante)}',
            style: TextStyle(
              color: estourou ? Colors.red.shade700 : Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final lista = _doMes;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PLANEJAMENTO',
                    style: textos.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Cores.verde,
                    ),
                  ),
                  Text(
                    'Orçamentos',
                    style: textos.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,  
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Defina um limite por categoria e acompanhe os gastos do mês',
                    style: textos.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: _abrirNovo,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        if (lista.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Nenhum orçamento neste mês. Toque no + para criar o primeiro',
            ),
          )
        else
          for (final o in lista) _item(o),
      ],
    );
  }
}
