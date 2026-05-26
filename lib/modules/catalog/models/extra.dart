class Extra {
  final int id;
  final String nome;
  final String categoria;
  final double preco;

  const Extra({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
  });

  factory Extra.fromMap(Map<String, dynamic> map) {
    return Extra(
      id: map['id'] as int,
      nome: map['nome'] as String,
      categoria: map['categoria'] as String,
      preco: (map['preco'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'categoria': categoria,
    'preco': preco,
  };
}
