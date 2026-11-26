import 'package:flutter/material.dart';

import '../services/controle_global.dart';

import 'package:intl/intl.dart';

import '../models/orcamento.dart';

//Guarda a categoria escolhida fora da classe. Como a inicio é recriada toda vez
//que troca de aba, essa aqui mantem a escolha
String? _categoriaSelecionada;

//O card muda quando o usuario escolhe a categoria escolhida
class CardOrcamento extends StatefulWidget {
  const CardOrcamento({super.key});

  @override
  State<CardOrcamento> createState() => _CardOrcamentoState();
}

class _CardOrcamentoState extends State<CardOrcamento> {
  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();

    //Todos os orçamentos do mês atual (cada categoria)
    final doMes = controle.orcamentos
        .where((o) => o.mes == hoje.month && o.ano == hoje.year)
        .toList();

    if (doMes.isEmpty) {
      return const Text('Nenhum orçamento cadastrado para este mês');
    }

    //Orcamento da categoria escolhida. Se não achar, usa o primeiro da lista
    final Orcamento orcamento = doMes.firstWhere(
      (o) => o.categoria.nome == _categoriaSelecionada,
      orElse: () => doMes.first,
    );

    final gasto = controle.calcularGastoOrcamento(orcamento);
    final restante = controle.calcularRestanteOrcamento(orcamento);
    final porcentagem = controle.calcularPorcentagemOrcamento(orcamento);
    final progresso = (porcentagem / 100).clamp(0.0, 1.0).toDouble();

    //No gráfico, verde normal, laranja a partir de 80%, vermelho quando estoura
    final corProgresso = restante < 0
        ? Colors.red.shade700
        : (porcentagem >= 80 ? Colors.orange.shade700 : Colors.green);

    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Orçamento mensal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    //Mostra de qual categoria é o orçamento exibido
                    Text(
                      orcamento.categoria.nome,
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              //Os tres pontinhos agora abrem um menu com as categorias
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
                tooltip: 'Trocar categoria',
                onSelected: (String nome) {
                  setState(() {
                    _categoriaSelecionada = nome;
                  });
                },
                itemBuilder: (context) => [
                  //um item para cada orçamento do mes, o selecionado aparece com um chack
                  for (final o in doMes)
                    CheckedPopupMenuItem<String>(
                      value: o.categoria.nome,
                      checked: o.categoria.nome == orcamento.categoria.nome,
                      child: Text(o.categoria.nome),
                    ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15),

          Text(
            'Limite definido',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          SizedBox(height: 5),

          Text(
            formatador.format(orcamento.limite),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: progresso, // indica a porcentage,
                      strokeWidth: 10, // espessura do circulo
                      backgroundColor:
                          Colors.grey.shade200, // cor restante do circulo
                      valueColor: AlwaysStoppedAnimation<Color>(
                        corProgresso,
                      ), // cor da parte preenchida
                    ),
                  ),

                  Text(
                    '${porcentagem.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gasto até agora',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  SizedBox(height: 5),

                  Text(
                    formatador.format(gasto),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Disponível',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    formatador.format(restante),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
