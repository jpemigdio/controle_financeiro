import 'categoria.dart';

class Gasto {
  String _descricao = "";
  double _valor = 0;
  late Categoria _categoria; // late informa ao Dart que o atributo será inicializado pelo construtor
  late DateTime _data;

  Gasto (String descricao, double valor, Categoria categoria, DateTime data) {
    this._descricao = descricao;
    this._valor = valor;
    this._categoria = categoria;
    this._data = data;
  }

  String get descricao => _descricao;

  double get valor => _valor;

  double get total => _valor;

  Categoria get categoria => _categoria;

  DateTime get data => _data;
}