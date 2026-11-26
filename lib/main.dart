import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'tema.dart';
import 'dados/dados_iniciais.dart';

//Liga o app, o tema e a primeira tela
void main() {
  carregarDadosIniciais();
  runApp(const ControleFinanceiro());
}

class ControleFinanceiro extends StatelessWidget {
  const ControleFinanceiro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finora', //tira a faixa DEBUG do canto
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
      home: const LoginScreen(),
    );
  }
}
