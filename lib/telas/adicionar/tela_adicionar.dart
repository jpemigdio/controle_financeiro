import 'package:flutter/material.dart';

import '../../modelos/transacao.dart';

//enum =  lista de opções fixas. os dois tipos possiveis
enum Tipo { despesa, receita }

const categorias = {
  'Alimentação': Icons.restaurant,
  'Transporte': Icons.directions_car,
  'Moradia': Icons.home,
  'Saúde': Icons.favorite,
  'Lazer': Icons.movie,
  'Receita': Icons.account_balance_wallet,
};

class TelaAdicionar extends StatefulWidget {
  const TelaAdicionar({super.key});

  @override
  State<TelaAdicionar> createState() => _TelaAdicionarState();
}

class _TelaAdicionarState extends State<TelaAdicionar> {
  //GlobalKey é uma "etiqueta" que identifica o formulário
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController(); //guarda o texto de um campo
  final _valorController = TextEditingController();

  //estado da tela, valores iniciais: abre como despesa, na categoria alimentação
  Tipo _tipo = Tipo.despesa;
  String _categoria = 'Alimentação';

  @override
  void dispose() {
    _nomeController
        .dispose(); //controllers precisam ser liberados, senao ocupam espaço
    _valorController.dispose(); //de memória depois que a tela some
    super.dispose();
  }

  //metodo para quando o usuario tocar em "Salvar transação"
  void salvar() {
    if (!_formKey.currentState!.validate()) return;
    final valorDigitado = double.parse(
      _valorController.text.replaceAll(',', '.'),
    );
  }
}
