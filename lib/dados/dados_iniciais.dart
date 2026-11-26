import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../models/gasto.dart';
import '../models/orcamento.dart';
import '../models/receita.dart';
import '../services/controle_global.dart';
import '../models/cofrinho.dart';

// Categoria -> ícone (o Categoria do parceiro só tem nome e descrição)
const iconesCategoria = {
  'Alimentação': Icons.restaurant,
  'Transporte': Icons.directions_car,
  'Moradia': Icons.home,
  'Saúde': Icons.favorite,
  'Lazer': Icons.movie,
};

void carregarDadosIniciais() {
  // Se já tem categorias, os dados já foram carregados.
  if (controle.categorias.isNotEmpty) {
    return;
  }

  //Dois exemplos do cofrinho (nome, valor guardado e meta)
  controle.adicionarCofrinho(Cofrinho('Viagem', 500.00, 3000.00));
  controle.adicionarCofrinho(
    Cofrinho('Reserva de emergência', 300.00, 1000.00),
  );

  // 1º: registrar as categorias (tudo abaixo depende delas)
  for (final nome in iconesCategoria.keys) {
    controle.adicionarCategoria(Categoria(nome, 'Despesas com $nome'));
  }

  // 2º: declarar "hoje" (usado nos lançamentos e nos orçamentos)
  final hoje = DateTime.now();

  // 3º: lançamentos de exemplo
  controle.adicionarGasto(
    Gasto(
      'Supermercado Pão de Açúcar',
      186.40, // no modelo do parceiro o gasto é POSITIVO
      controle.buscarCategoria('Alimentação')!,
      hoje,
    ),
  );
  controle.adicionarGasto(
    Gasto(
      'Uber',
      28.90,
      controle.buscarCategoria('Transporte')!,
      hoje.subtract(const Duration(minutes: 1)),
    ),
  );
  controle.adicionarReceita(
    Receita(
      'Salário mensal',
      5200.00,
      hoje.subtract(const Duration(minutes: 2)),
    ),
  );

  // 4º: orçamentos de exemplo para o mês atual
  controle.adicionarOrcamento(
    Orcamento(
      controle.buscarCategoria('Alimentação')!,
      800.00,
      hoje.month,
      hoje.year,
    ),
  );
  controle.adicionarOrcamento(
    Orcamento(
      controle.buscarCategoria('Transporte')!,
      200.00,
      hoje.month,
      hoje.year,
    ),
  );
}
