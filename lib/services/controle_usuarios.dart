
import '../models/usuario.dart';

class ControleUsuarios {
  Usuario? usuarioCadastrado;

  bool cadastrar(Usuario usuario) {
    usuarioCadastrado = usuario;
    return true;
  }

  bool autenticar(String email, String senha) {
    if (usuarioCadastrado == null) {
      return false;
    }

    return usuarioCadastrado!.email == email &&
        usuarioCadastrado!.senha == senha;
  }
}
