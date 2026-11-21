import 'package:flutter/material.dart';

import 'tema.dart';
import './app_shell.dart';

//Liga o app, o tema e a primeira tela
void main() {
  runApp(const ControleFinanceiro());
}

class ControleFinanceiro extends StatelessWidget {
  const ControleFinanceiro({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //tira a faixa DEBUG do canto
      theme: criacaoTema(),
      builder: (context, child) {
        return ColoredBox(
          color: const Color(0xFFE9EEEC),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          ),
        );
      },
      home: const AppShell(),
    );
  }
}
