class Usuario {
  final String id;
  final String nomeUsuario;
  final String emailCorporativoUsuario;
  final String senhaUsuario;

  Usuario({
    required this.id,
    required this.nomeUsuario,
    required this.emailCorporativoUsuario,
    required this.senhaUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['_id'] ?? '',
      nomeUsuario: json['nome_usuario'],
      emailCorporativoUsuario: json['email_corporativo_usuario'],
      senhaUsuario: json['senha_usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nome_usuario': nomeUsuario,
      'email_corporativo_usuario': emailCorporativoUsuario,
      'senha_usuario': senhaUsuario,
    };
  }
}
