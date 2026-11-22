import 'package:flutter/material.dart';
import '../modelos/transacao.dart';

// final nesse caso significa que a variavel sempre aponta para esta mesma lista
// mas o Conteudo pode crescer com .add() ou insert().
//O List<Transacao> diz que a lista guarda somente objetos do tipo Transacao
//Está fora de qualquer classe, entao qualquer arquivo que importe este
//pode ler e alterar a lista (uma lista "global").

final List<Transacao> transacoes = [
  Transacao('Supermercado Pão de Açucar','Alimentação',-186.40,Icons.restaurant),
  Transacao('Salário mensal', 'Receita', 5200.00, Icons.account_balance_wallet),
  Transacao('Uber', 'Transporte', -28.90, Icons.directions_car),
];  