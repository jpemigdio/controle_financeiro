import 'package:flutter/material.dart';
import '../services/controle_global.dart';
import 'package:intl/intl.dart';

class CardOrcamento extends StatelessWidget {
  const CardOrcamento({super.key});

  @override
  Widget build(BuildContext context) {

    final orcamento = controle.buscarOrcamentoAtual();

    if(orcamento == null) {
      return Text('Nenhum orçamento cadastrado para este mês');
    }

    final gasto = controle.calcularGastoOrcamento(orcamento);
    final restante = controle.calcularRestanteOrcamento(orcamento);
    final porcentagem = controle.calcularPorcentagemOrcamento(orcamento);
    final progresso = (porcentagem / 100).clamp(0.0, 1.0).toDouble();

    final formatador = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orçamento mensal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Icon(
                Icons.more_horiz,
                color: Colors.grey,
              ),
            ],
          ),

          SizedBox(height: 15),

          Text(
            'Limite definido',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          SizedBox(height: 5),

          Text(
            formatador.format(orcamento.limite),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
                    backgroundColor: Colors.grey.shade200, // cor restante do circulo
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // cor da parte preenchida
                  ),
                ),
                
                Text(
                  '${porcentagem.toStringAsFixed(0)}%',
                  style: TextStyle(
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
                Text(
                  'Gasto até agora',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  formatador.format(gasto),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Disponível',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  formatador.format(restante),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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