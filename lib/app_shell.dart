import 'package:flutter/material.dart';
import 'telas/inicio/tela_inicio.dart';
import 'telas/transacoes/tela_transacoes.dart';
import 'telas/relatorios/tela_relatorios.dart';
import 'telas/orcamentos/tela_orcamentos.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 1; //estado da classe, a tela se inicia a partir da aba 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(// empurra o conteudo para longe da camera e barra de status, para nada ficar escondido
        child: IndexedStack(
          index: _index,
          children: const [
            TelaInicio(),
            TelaTransacoes(),
            TelaRelatorios(),
            TelaOrcamentos(),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        //barra fixa embaixo
        selectedIndex: _index,
        onDestinationSelected: (int i) {
          //funcao anonima
          setState(() {
            _index = i;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),

          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            label: 'Transações',
          ),

          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),

          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Orçamentos',
          ),
        ],
      ),
    );
  }
}
