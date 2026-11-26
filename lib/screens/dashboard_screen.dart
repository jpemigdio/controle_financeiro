import 'package:flutter/material.dart';
import '../widgets/card_orcamento.dart';
import '../services/controle_global.dart';
import 'package:intl/intl.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen ({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {

    final saldo = controle.calcularSaldo();
    final receitas = controle.calcularTotalReceitas();
    final despesas = controle.calcularTotal();

    final formatador = NumberFormat.currency( // formatar para R$ 0,00
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final List<Map<String, dynamic>> movimentacoes = [
      for (final gasto in controle.gastos)
      {
        'descricao': gasto.descricao,
        'valor': gasto.valor,
        'data': gasto.data,
        'tipo': 'Despesa',
      },

      for (final receita in controle.receitas) 
      {
        'descricao': receita.descricao,
        'valor': receita.valor,
        'data': receita.data,
        'tipo': 'Receita',
      },
    ];

    // Ordenação das movimentações por data
    movimentacoes.sort((a, b) {
      return b['data'].compareTo(a['data']);
    });

    // Exibe no máximo as ultimas 5 movimentações
    final ultimasMovimentacoes = movimentacoes.take(5).toList();

    return Scaffold(
      body: SingleChildScrollView( // permite rolar a tela
        child: Padding(
          padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${controleUsuarios.usuarioCadastrado?.nome ?? 'Usuário'}!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Seu resumo financeiro',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration( // personaliza a aparência do card
                color: Color(0xFF176B3A),
                borderRadius: BorderRadius.circular(20), // arredonda os cantos
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saldo disponível',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          ),
                        ),

                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 10),

                  Text(
                    formatador.format(saldo),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Seu saldo atual',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            Row( // Organiza elementos horizontalmente
              children: [
                Expanded( // divide o espaço disponível entre os elementos
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50, // tom bem claro de verde
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.green.shade800,
                            size: 20,
                          ),
                        ),
                        
                        SizedBox(height: 10),
                        Text('Receitas'),
                        SizedBox(height: 5),
                        Text(
                          formatador.format(receitas),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 15),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.red.shade800,
                            size: 20,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text('Despesas'),

                        SizedBox(height: 5),

                        Text(
                          formatador.format(despesas),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            CardOrcamento(),

            SizedBox(height: 25),

            Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.green.shade700,
                  size: 23,
                ),

                SizedBox(width: 8),

                Text(
                  'Últimas movimentações',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            SizedBox(height: 15),

            if (ultimasMovimentacoes.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // Cinza suave
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text('Nenhuma movimentação cadastrada'),
              )
            else
              Column(
                children: [
                  for (final movimentacao in ultimasMovimentacoes)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: movimentacao['tipo'] == 'Receita'
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              movimentacao['tipo'] == 'Receita'
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                              color: movimentacao['tipo'] == 'Receita'
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                              size: 20,
                            ),
                          ),

                          SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movimentacao['descricao'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  movimentacao['tipo'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(height: 3),

                                Text(
                                  DateFormat('dd/MM/yyyy').format(movimentacao['data']),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            formatador.format(movimentacao['valor']),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: movimentacao['tipo'] == 'Receita'
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}