import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/controle_global.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen ({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {

  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  @override
  void dispose() {
  _senhaController.dispose();
  _nomeController.dispose();
  _emailController.dispose();
  super.dispose();
}


void mostrarMensagem(String titulo, String mensagem, bool sucesso) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              sucesso ? Icons.check_circle : Icons.error,
              color: sucesso ? Colors.green : Colors.red,
            ),
            SizedBox(width: 10),
            Text(titulo),
          ],
        ),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (sucesso) {
                Navigator.pop(this.context);
              }
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF176B3A),
              ),
            ),
          ),
        ],
      );
    },
  );
}


  
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFFF5F8F5),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Cadastro - Finora',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF176B3A),
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              'Crie sua conta no Finora e controle seus gastos',
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 20),

                            TextFormField(
                              controller: _nomeController,
                              decoration: InputDecoration(
                                labelText: 'Nome',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Preencha seu nome';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Digite um e-mail válido';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            TextFormField(
                              controller: _senhaController,
                              obscureText: !_senhaVisivel,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _senhaVisivel = !_senhaVisivel;
                                    });
                                  },
                                )
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite uma senha';
                                }

                                if (value.length < 6) {
                                  return 'A senha deve ter pelo menos 6 caracteres';
                                }

                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            TextFormField(
                              obscureText: !_confirmarSenhaVisivel,
                              decoration: InputDecoration(
                                labelText: 'Confirmar senha',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _confirmarSenhaVisivel
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirme sua senha';
                                }

                                if (value != _senhaController.text) {
                                  return 'As senhas não coincidem';
                                }

                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final usuario = Usuario(
                                      nome: _nomeController.text,
                                      email: _emailController.text,
                                      senha: _senhaController.text,
                                    );

                                    controleUsuarios.cadastrar(usuario);

                                    mostrarMensagem(
                                      'Cadastro realizado!',
                                      'Sua conta no Finora foi criada com sucesso!! Agora você já pode fazer o login.',
                                      true,
                                    );
                                  } else {
                                    mostrarMensagem(
                                      'Atenção!',
                                      'Por favor, preencha todos os campos corretamente.',
                                      false,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF176B3A),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Criar conta'),
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Já possui conta? Entrar',
                                style: TextStyle(
                                  color: Color(0xFF176B3A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}