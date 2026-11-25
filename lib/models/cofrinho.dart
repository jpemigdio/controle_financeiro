class Cofrinho {

  String _nome = "";
  double _valorGuardado = 0;
  double _meta = 0;

  Cofrinho(String nome, double valorGuardado, double meta) {
    this._nome = nome;
    this._valorGuardado = valorGuardado;
    this._meta = meta;
  }

  String get nome => _nome;
  double get valorGuardado => _valorGuardado;
  double get meta => _meta;

  void adicionarDinheiro(double valorGuardado) {
    _valorGuardado += valorGuardado;
  }

  void retirarDinheiro(double valor) {
    if (valor < 0 || valor > valorGuardado) {
      print('Valor de retirada inválido');
    } else {
      _valorGuardado -= valor;
    }
  }

  double calcularRestante() {
    return meta - valorGuardado;
  }

  double calcularProgresso() {
    return valorGuardado / meta * 100;
  }
}