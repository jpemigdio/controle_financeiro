import 'package:flutter/material.dart';

//classe transação
class Transacao {
  final String nome;
  final String categoria;
  final double valor;
  final IconData icone;

  const Transacao(this.nome, this.categoria, this.valor, this.icone);
}