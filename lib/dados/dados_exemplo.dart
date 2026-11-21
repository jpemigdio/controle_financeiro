import 'package:flutter/material.dart';
import '../modelos/transacao.dart';

// uma lista fixa de dados de exemplo de uma transação
const transacoes = [
  Transacao(
    'Supermercado Pão de Açucar',
    'Alimentação',
    -186.40,
    Icons.restaurant,
  ),
  Transacao('Salário mensal', 'Receita', 5200.00, Icons.account_balance_wallet),
  Transacao('Uber', 'Transporte', -28.90, Icons.directions_car),
];