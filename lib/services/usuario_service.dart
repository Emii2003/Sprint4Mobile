import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  final String baseUrl = "http://127.0.0.1:8000/usuario";  // Altere para o IP real da sua API

  Future<List<Usuario>> getUsuarios() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Usuario.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao carregar usuários');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com a API: $e');
    }
  }

  Future<Usuario> getUsuarioById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao carregar usuário');
    }
  }

  Future<void> createUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao criar usuário');
    }
  }

  Future<void> updateUsuario(String id, Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }

  Future<void> deleteUsuario(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário');
    }
  }
}
