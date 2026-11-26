import 'package:flutter/material.dart';

//função simples para mudar a cor do app

//Classe pra usar as cores em TODAS as telas
//Mudou aqui, muda no app inteiro
class Cores {
  static const verde = Color(0xFF176B3A);
  static const fundo = Color(0xFFF5F8F5);
}

ThemeData criacaoTema() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Cores.verde),
    scaffoldBackgroundColor: Cores.fundo,
    useMaterial3: true,
  );
}
