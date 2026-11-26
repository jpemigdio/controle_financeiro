import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/cofrinho.dart';
import '../../services/controle_global.dart';
import '../../tema.dart';
import '../../widgets/cartao_resumo.dart';
import 'tela_novo_cofrinho.dart';

final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

String _moeda(double v) => _formatoMoeda.format(v);

class TelaCofrinho extends StatefulWidget {
  const TelaCofrinho({super.key});

  @override
  State<TelaCofrinho> createState() => _TelaCofrinhoState();
}

class _TelaCofrinhoState extends State<TelaCofrinho> {
  // O formulário grava direto no controle; ao voltar, redesenha a tela
  Future<void> _abrirNovo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaNovoCofrinho()),
    );
    if (mounted) {
      setState(() {});
    }
  }

  // Guardar (guardar: true) ou retirar (guardar: false)
  Future<void> _movimentar(Cofrinho c, {required bool guardar}) async {
    final saldo = controle.calcularSaldo();

    // Limite do valor:
    //   guardar -> no máximo o saldo disponível (nunca negativo)
    //   retirar -> no máximo o que já está guardado neste cofrinho
    final limite = guardar ? (saldo < 0 ? 0.0 : saldo) : c.valorGuardado;

    // showDialog<double> abre o diálogo e ESPERA ele devolver um número
    // (ou null se a pessoa cancelar).
    final valor = await showDialog<double>(
      context: context,
      builder: (context) => _DialogoMovimento(
        titulo: guardar ? 'Guardar em ${c.nome}' : 'Retirar de ${c.nome}',
        textoBotao: guardar ? 'Guardar' : 'Retirar',
        limite: limite,
        mensagemLimite: guardar
            ? 'Maior que o saldo disponível'
            : 'Maior que o valor guardado',
      ),
    );

    if (valor == null || !mounted) {
      return;
    }

    setState(() {
      // Os métodos do modelo do parceiro fazem a conta
      if (guardar) {
        c.adicionarDinheiro(valor);
      } else {
        c.retirarDinheiro(valor);
      }
    });
  }

  Future<void> _remover(Cofrinho c) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover ${c.nome}?'),
        content: Text(
          c.valorGuardado > 0
              ? 'Os ${_moeda(c.valorGuardado)} guardados voltam para o seu saldo disponível.'
              : 'Este cofrinho será removido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmou == true && mounted) {
      setState(() {
        controle.removerCofrinho(c);
      });
    }
  }

  Widget _item(Cofrinho c) {
    // calcularProgresso() devolve em % (0 a 100+); a barra quer 0.0 a 1.0
    final progresso = (c.calcularProgresso() / 100).clamp(0.0, 1.0).toDouble();
    final atingiu = c.valorGuardado >= c.meta;
    final cor = atingiu ? Colors.amber.shade800 : Cores.verde;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.savings, color: cor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Meta ${_moeda(c.meta)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                tooltip: 'Remover cofrinho',
                onPressed: () => _remover(c),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progresso,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.grey.shade200,
            color: cor,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Guardado ${_moeda(c.valorGuardado)}'),
              Text(
                '${c.calcularProgresso().toStringAsFixed(0)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: cor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            atingiu
                ? 'Meta atingida!'
                : 'Faltam ${_moeda(c.calcularRestante())}',
            style: TextStyle(
              color: atingiu ? Colors.amber.shade800 : Colors.grey.shade700,
              fontSize: 13,
              fontWeight: atingiu ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => _movimentar(c, guardar: true),
                  child: const Text('Guardar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  // Sem nada guardado, não há o que retirar
                  onPressed: c.valorGuardado > 0
                      ? () => _movimentar(c, guardar: false)
                      : null,
                  child: const Text('Retirar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final lista = controle.cofrinhos;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'METAS',
                    style: textos.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Cores.verde,
                    ),
                  ),
                  Text(
                    'Meu cofrinho',
                    style: textos.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Guarde dinheiro para seus objetivos. O valor guardado sai do saldo disponível.',
                    style: textos.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: _abrirNovo,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Resumo: mostra o efeito da regra (guardado x disponível)
        CartaoResumo(
          icone: Icons.savings,
          titulo: 'Total guardado',
          valor: _moeda(controle.calcularTotalCofrinhos()),
          observacao: '${lista.length} cofrinho(s)',
          cor: Cores.verde,
          corFundo: Colors.green.shade50,
        ),
        CartaoResumo(
          icone: Icons.account_balance_wallet_outlined,
          titulo: 'Saldo disponível',
          valor: _moeda(controle.calcularSaldo()),
          observacao: 'disponível para guardar',
          cor: Colors.indigo.shade700,
          corFundo: Colors.indigo.shade50,
        ),
        const SizedBox(height: 8),

        if (lista.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Nenhum cofrinho ainda. Toque no + para criar o primeiro.',
            ),
          )
        else
          for (final c in lista) _item(c),
      ],
    );
  }
}

// Diálogo que pede um valor e o DEVOLVE com Navigator.pop.
// É StatefulWidget porque tem um Form e um controller para liberar.
class _DialogoMovimento extends StatefulWidget {
  const _DialogoMovimento({
    required this.titulo,
    required this.textoBotao,
    required this.limite,
    required this.mensagemLimite,
  });

  final String titulo;
  final String textoBotao;
  final double limite; // valor máximo aceito
  final String mensagemLimite; // erro quando passa do máximo

  @override
  State<_DialogoMovimento> createState() => _DialogoMovimentoState();
}

class _DialogoMovimentoState extends State<_DialogoMovimento> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // "186,40" -> 186.40; devolve null se não for um número
  double? _lerValor(String? texto) {
    return double.tryParse((texto ?? '').replaceAll(',', '.'));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Valor',
            prefixText: 'R\$ ',
            helperText: 'Máximo: ${_moeda(widget.limite)}',
            border: const OutlineInputBorder(),
          ),
          validator: (String? texto) {
            final v = _lerValor(texto);
            if (v == null || v <= 0) {
              return 'Informe um valor maior que zero';
            }
            // 0.005 = tolerância de meio centavo, por causa das contas
            // com números decimais do computador
            if (v > widget.limite + 0.005) {
              return widget.mensagemLimite;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final v = _lerValor(_controller.text)!;
            // Devolve o valor (limitado ao máximo) para quem abriu o diálogo
            Navigator.pop(context, v > widget.limite ? widget.limite : v);
          },
          child: Text(widget.textoBotao),
        ),
      ],
    );
  }
}
