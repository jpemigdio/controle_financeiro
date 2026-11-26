import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../services/controle_global.dart';

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

  //Roda uma vez, no main(). Registra só as categorias, que o app precisa
  //para funcionar: alimentam o menu de despesas e orçamentos

  for (final nome in iconesCategoria.keys) {
    controle.adicionarCategoria(Categoria(nome, 'Despesas com $nome'));
  }
}
