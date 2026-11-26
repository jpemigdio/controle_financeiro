import 'package:flutter/material.dart';

import '../../models/cofrinho.dart';
import '../../services/controle_global.dart';

class TelaNovoCofrinho extends StatefulWidget {
  const TelaNovoCofrinho({super.key});

  @override
  State<TelaNovoCofrinho> createState() => _TelaNovoCofrinhoState();
}

class _TelaNovoCofrinhoState extends State<TelaNovoCofrinho> {
  final _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _metaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _metaController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (! _formkey.currentState!.validate()) {
      return;
    }


  final meta = double.parse(_metaController.text.replaceAll(',', '.'));

  controle.adicionarCofrinho(
    Cofrinho(_nomeController.text.trim(), 0, meta),
  );

  Navigator.pop(context, true);
}


@override 
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Novo confrinho')),
    body: SafeArea(
      child: Form(key: _formkey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome do cofrinho',
              hintText: 'Ex: Viagem, Notebook novo',
              border: OutlineInputBorder(),
            ),
            validator: (String? texto){
              final nome = (texto ?? '').trim();
              if (nome.isEmpty) {
                return 'Informe um nome';
              }
              final repetido = controle.cofrinhos.any(
                (c) => c.nome.toLowerCase() == nome.toLowerCase(),
              );
              if (repetido) {
                return 'Já existe um cofrinho com esse nome';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _metaController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Meta',
              prefixText: 'R\$',
              border: OutlineInputBorder(),
            ),
            validator: (String? texto){
              final numero =
                double.tryParse((texto ?? '').replaceAll(',', '.'));
                if (numero == null ||  numero <= 0) {
                  return 'Informe uma meta maior que zero';
                }
                return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _salvar,
            child: const Text('Criar cofrinho'),
          ),
        ],
          ),
      ),
    ),
  );
}
}