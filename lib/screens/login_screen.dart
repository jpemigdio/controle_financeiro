import 'package:flutter/material.dart';
import 'cadastro_screen.dart';
import '../app_shell.dart';
import '../services/controle_global.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _senhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppShell(),
                  ),
                );
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
    body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFFF5F8F5),
      child: SafeArea(
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
                      constraints: BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Finora',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF176B3A),
                                ),
                              ),

                              SizedBox(height: 10),
                              Text('Faça seu login'),
                              SizedBox(height: 30),

                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains('@')) {
                                    return 'Digite seu e-mail';
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
                                    onPressed: () {
                                      setState(() {
                                        _senhaVisivel = !_senhaVisivel;
                                      });
                                    },
                                    icon: Icon(
                                      _senhaVisivel
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite sua senha';
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
                                          final autenticado = controleUsuarios.autenticar(
                                            _emailController.text.trim(),
                                            _senhaController.text,
                                          );

                                          if (autenticado) {
                                            mostrarMensagem(
                                              'Login realizado!',
                                              'Seja bem-vindo de volta ao Finora!',
                                              true,
                                            );
                                          } else {
                                            mostrarMensagem(
                                            'Acesso negado!',
                                            'E-mail ou senha incorretos. Verifique seus dados.',
                                            false,
                                          );
                                        }
                                      } else {
                                        mostrarMensagem(
                                          'Atenção!',
                                          'Por favor, preencha os campos corretamente.',
                                          false,
                                        );
                                      }
                                    },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF176B3A),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Entrar'),
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AppShell(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Não possui conta? Cadastre-se',
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
      ),
    );
  }
}

