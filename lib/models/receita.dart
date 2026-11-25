class Receita {

  String _descricao = "";
  double _valor = 0;
  late DateTime _data;

  Receita(String descricao, double valor, DateTime data) {
    this._descricao = descricao;
    this._valor = valor;
    this._data = data;
  }

  String get descricao => _descricao;
  double get valor => _valor;
  DateTime get data => _data;

}