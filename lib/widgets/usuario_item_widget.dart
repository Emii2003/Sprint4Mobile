import 'package:flutter/material.dart';
import '../models/usuario.dart';

class UsuarioItemWidget extends StatelessWidget {
  final Usuario usuario;

  const UsuarioItemWidget({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nomeUsuario),
      subtitle: Text(usuario.emailCorporativoUsuario),
      onTap: () {
        // Navegar para detalhes do usuário (caso necessário)
      },
    );
  }
}
