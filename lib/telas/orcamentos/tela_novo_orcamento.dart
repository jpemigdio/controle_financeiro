import 'package:flutter/material.dart';

import '../../models/orcamento.dart';
import '../../services/controle_global.dart';

class TelaNovoOrcamento extends StatefulWidget {
  const TelaNovoOrcamento({super.key});

  @override
  State<TelaNovoOrcamento> createState() => _TelaNovoOrcamentoState();
}

class _TelaNovoOrcamentoState extends State<TelaNovoOrcamento> {
  final _formKey = GlobalKey<FormState>();
  final _limiteController = TextEditingController();

  // Começa na primeira categoria registrada (carregadas no main)
  String _categoria = controle.categorias.first.nome;

  @override
  void dispose() {
    _limiteController.dispose();
    super.dispose();
  }

  // Já existe orçamento desta categoria neste mês?
  // .any(...) devolve true se ALGUM item da lista passar no teste
  bool _jaExiste(String nome) {
    final agora = DateTime.now();
    return controle.orcamentos.any((o) =>
        o.categoria.nome == nome && o.mes == agora.month && o.ano == agora.year);
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final limite = double.parse(_limiteController.text.replaceAll(',', '.'));
    final agora = DateTime.now();

    // Usa o objeto Categoria JÁ registrado: o cálculo do gasto compara
    // pelo objeto, então não pode ser uma Categoria nova.
    controle.adicionarOrcamento(Orcamento(
      controle.buscarCategoria(_categoria)!,
      limite,
      agora.month,
      agora.year,
    ));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo orçamento')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: controle.categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria.nome,
                    child: Text(categoria.nome),
                  );
                }).toList(),
                onChanged: (String? nova) {
                  if (nova == null) {
                    return;
                  }
                  setState(() {
                    _categoria = nova;
                  });
                },
                // Impede dois orçamentos da mesma categoria no mês
                validator: (String? nome) {
                  if (nome != null && _jaExiste(nome)) {
                    return 'Já existe um orçamento desta categoria neste mês';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limiteController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Limite mensal',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (String? texto) {
                  final numero =
                      double.tryParse((texto ?? '').replaceAll(',', '.'));
                  if (numero == null || numero <= 0) {
                    return 'Informe um valor maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _salvar,
                child: const Text('Salvar orçamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}