import 'package:controle_financeiro/models/receita.dart';
import '../models/gasto.dart';
import '../models/cofrinho.dart';
import '../models/categoria.dart';

class ControleFinanceiro {
  List<Gasto> gastos = [];

  List<Receita> receitas = [];

  List<Cofrinho> cofrinhos = [];

  List<Categoria> categorias = [];

  double calcularTotal() {
    double total = 0;

    for (Gasto gasto in gastos) {
      total += gasto.valor;
    }

    return total;
  }

  void adicionarGasto(Gasto gasto) {
    gastos.add(gasto);
  }

  void removerGasto(Gasto gasto) {
    gastos.remove(gasto);
  }

  void adicionarReceita(Receita receita) {
    receitas.add(receita);
  }

  double calcularTotalReceitas() {

    double total = 0;

    for (Receita receita in receitas) {
      total += receita.valor;
    }

    return total;
  }

  double calcularSaldo() {
    return calcularTotalReceitas() - calcularTotal();
  }

  void adicionarCofrinho(Cofrinho cofrinho) {
    cofrinhos.add(cofrinho);
  }

  void removerCofrinho(Cofrinho cofrinho) {
    cofrinhos.remove(cofrinho);
  }

  double calcularTotalCofrinhos() {

    double totalcofrinhos = 0;

    for (Cofrinho cofrinho in cofrinhos) {
      totalcofrinhos += cofrinho.valorGuardado;
      
    }
    
    return totalcofrinhos;
  }

  void adicionarCategoria(Categoria categoria) {
    categorias.add(categoria);
  }

  void removerCategoria(Categoria categoria) {
    categorias.remove(categoria);
  }

  double calcularGastosPorCategoria(Categoria categoria) {

    double valortotal = 0;

    for (Gasto gasto in gastos) {
      if(gasto.categoria == categoria) {
        valortotal += gasto.valor;
      }
    }

    return valortotal;
  }

  Categoria? buscarCategoria(String nome) {

    for (Categoria categoria in categorias) {
      if (categoria.nome == nome) {
        return categoria;
      }
    }

    return null;
  }

  List<Categoria> listarCategorias() {
    return categorias;
  }

  double calcularPorcentagemCategoria(Categoria categoria) {
    if (calcularTotal() <= 0) {
      return 0;
    }

    return calcularGastosPorCategoria(categoria) / calcularTotal() * 100;
  }

  double calcularGastosPorMes(int mes, int ano) {

    double total = 0;

    for (Gasto gasto in gastos) {
      if (gasto.data.month == mes && gasto.data.year == ano) {
        total += gasto.valor;
      }
    }

    return total;
  }

  double calcularReceitasPorMes(int mes, int ano) {

    double total = 0;

    for (Receita receita in receitas) {
      if (receita.data.month == mes && receita.data.year == ano) {
        total += receita.valor;
      }
    }

    return total;
  }

  double calcularSaldoPorMes(int mes, int ano) {
    return calcularReceitasPorMes(mes, ano) - calcularGastosPorMes(mes, ano); 
  }
}