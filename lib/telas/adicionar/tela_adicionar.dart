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
    _nomeController.dispose(); //controllers precisam ser liberados, senao ocupam espaço
    _valorController.dispose(); //de memória depois que a tela some
    super.dispose();
  }

  //metodo para quando o usuario tocar em "Salvar transação"
  void salvar() {
    //validate executa todos os campos do formulário, devolve false tiver algum erro
    if (!_formKey.currentState!.validate())
      return; // o ! diz "garante que não é null"
    final valorDigitado = double.parse(
      _valorController.text.replaceAll(',', '.'),
    );
    final valor = _tipo == Tipo.despesa ? -valorDigitado : valorDigitado; //regra, despesa guarda valor negativo e receita positivo
    final nova = Transacao(
      //segue construtor de Transacao
      _nomeController.text.trim(), //trim() remove espaços do começo e do fim
      _categoria,
      valor,
      categorias[_categoria]!,
    );
    Navigator.pop(context, nova); //pop fecha a tela e volta para a anterior
    //(nova) é o valor devolvido para quem abriu a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova transação')),
      body: SafeArea(
        child: //evita que o conteudo fique atras das barras do sistema
        Form(
          key: _formKey,
          child: ListView(
            //para a tela rolar, com o teclado aberto, uma column nao caberia e daria erro de conteudo passando da tela
            padding: const EdgeInsets.all(16),
            children: [
              //<Tipo> diz que cada botao carrega um valor do enum Tipo
              SegmentedButton<Tipo>(
                segments: const [
                  ButtonSegment(value: Tipo.despesa, label: Text('Despesa')),
                  ButtonSegment(value: Tipo.receita, label: Text('Receita')),
                ],
                selected: {_tipo}, //recebe um Set, por isso a chave
                //chamado quando a pessoa toca em um outro botao
                onSelectionChanged: (Set<Tipo> escolhido) {
                  setState(() {
                    _tipo = escolhido.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController, //guarda o que for digitado
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(), //borda em volta do campo
                ),
                validator: (String? texto) {
                  //o parametro do string? (pode ser null) por isso o teste "texto == null"
                  if (texto == null || texto.trim().isEmpty) {
                    return 'Informe uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                keyboardType: //abre o teclado numero, com opcao de virgula e ponto decimal
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$', //fixo antes do que se digita
                  border: OutlineInputBorder(),
                ),
                validator: (String? texto) {
                  // o ?? se for null usa o texto vazio, tryparse devolve null se o texto nao for um numero
                  final numero = double.tryParse(
                    (texto ?? '').replaceAll(',', '.'),
                  );

                  //invalido se nao é numero ou se é zero/negativo
                  //o sinal é decidido pelo botao de despesa/receita
                  if (numero == null || numero <= 0) {
                    return 'Informe um valor maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              //CATEGORIA
              //<String> porque cada item do menu é um texto
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                //monta a lista de itens a partir das chaves do map
                //para cada nome cria um item do menu
                items: categorias.keys.map((String nome) {
                  return DropdownMenuItem(value: nome, child: Text(nome));
                }).toList(),
                //chamado quando a pessoa escolhe outro item
                //string? porque o flutter pode mandar null
                onChanged: (String? novaCategoria) {
                  if (novaCategoria == null) return;
                  setState(() {
                    _categoria = novaCategoria;
                  });
                },
              ),
              const SizedBox(height: 24),

              //botao para salvar
              FilledButton(
                onPressed: salvar,
                child: const Text('Salvar transação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
