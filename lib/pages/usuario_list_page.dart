import 'package:flutter/material.dart';
import '../services/usuario_service.dart';
import '../models/usuario.dart';

class UsuarioListPage extends StatefulWidget {
  @override
  _UsuarioListPageState createState() => _UsuarioListPageState();
}

class _UsuarioListPageState extends State<UsuarioListPage> {
  final UsuarioService usuarioService = UsuarioService();
  List<Usuario> usuarios = [];
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    try {
      final fetchedUsuarios = await usuarioService.getUsuarios();
      setState(() {
        usuarios = fetchedUsuarios;
      });
    } catch (e) {
      print('Erro ao carregar usuários: $e');
    }
  }

  Future<void> _createUsuario() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      return;
    }

    final usuario = Usuario(
      id: '',  // O ID será gerado pelo banco
      nomeUsuario: nome,
      emailCorporativoUsuario: email,
      senhaUsuario: senha,
    );

    try {
      await usuarioService.createUsuario(usuario);
      _loadUsuarios();
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário cadastrado com sucesso!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar usuário')));
    }
  }

  Future<void> _deleteUsuario(String id) async {
    try {
      await usuarioService.deleteUsuario(id);
      _loadUsuarios();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário deletado com sucesso!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao deletar usuário')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      body: Column(
        children: [
          // Formulário de Cadastro de Usuário
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email Corporativo'),
                ),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createUsuario,
                  child: Text('Cadastrar Usuário'),
                ),
              ],
            ),
          ),

          // Listagem de Usuários
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return ListTile(
                  title: Text(usuario.nomeUsuario),
                  subtitle: Text(usuario.emailCorporativoUsuario),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteUsuario(usuario.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
