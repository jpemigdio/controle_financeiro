import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart'; //tela de inicio
import 'telas/transacoes/tela_transacoes.dart';
import 'telas/cofrinho/tela_cofrinho.dart';
import 'telas/orcamentos/tela_orcamentos.dart';
import 'screens/login_screen.dart';
import 'tema.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0; //estado da classe, a tela se inicia a partir da aba 0 (login)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //sem a seta para voltar
        backgroundColor: Colors.white,
        toolbarHeight: 65,
        title: const Text(
          'Finora',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Cores.verde,
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Cores.verde),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        // empurra o conteudo para longe da camera e barra de status, para nada ficar escondido
        child: switch (_index) {
          0 => const DashboardScreen(),
          1 => const TelaTransacoes(),
          2 => const TelaCofrinho(),
          _ => const TelaOrcamentos(),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int i) {
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
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Cofrinho'),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Orçamentos',
          ),
        ],
      ),
    );
  }
}
