import 'package:controle_financeiro/models/categoria.dart';

class Orcamento {
  late Categoria _categoria;
  double _limite = 0;
  int _mes = 0;
  int _ano = 0;

  Orcamento (Categoria categoria, double limite, int mes, int ano) {
    this._categoria = categoria;
    this._limite = limite;
    this._mes = mes;
    this._ano = ano;
  }
  
  Categoria get categoria => _categoria;
  double get limite => _limite;
  int get mes => _mes;
  int get ano => _ano;
}