class Sabor {
  final int id;
  final String nome;
  final double preco;

  const Sabor({required this.id, required this.nome, required this.preco});

  factory Sabor.fromMap(Map<String, dynamic> map) {
    return Sabor(
      id: map['id'] as int,
      nome: map['nome'] as String,
      preco: (map['preco'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'nome': nome, 'preco': preco};
}
