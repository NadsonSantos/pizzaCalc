class Cliente {
  final int id;
  final String nome;
  final String telefone;
  final String? endereco;

  const Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.endereco,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] as int,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
      endereco: map['endereco'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'endereco': endereco,
      };

  Cliente copyWith({
    int? id,
    String? nome,
    String? telefone,
    String? endereco,
    bool clearEndereco = false,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      endereco: clearEndereco ? null : (endereco ?? this.endereco),
    );
  }
}
