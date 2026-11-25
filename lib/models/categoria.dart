class Categoria {

  String _nome = "";
  String _descricao = "";

  Categoria(String nome, String descricao) {
    this._nome = nome;
    this._descricao = descricao;
  }

  String get nome => _nome;
  String get descricao => _descricao;
}