import '../../modules/catalog/models/extra.dart';
import '../../modules/catalog/models/sabor.dart';

class SeedData {
  static const sabores = [
    Sabor(id: 1, nome: 'Baiana', preco: 30),
    Sabor(id: 2, nome: 'Bacon', preco: 30),
    Sabor(id: 3, nome: 'Batata Palha', preco: 30),
    Sabor(id: 4, nome: 'Calabresa', preco: 30),
    Sabor(id: 5, nome: 'Catupiry', preco: 30),
    Sabor(id: 6, nome: 'Cheddar', preco: 30),
    Sabor(id: 7, nome: 'Frango', preco: 30),
    Sabor(id: 8, nome: 'Milho', preco: 30),
    Sabor(id: 9, nome: 'Mussarela', preco: 30),
    Sabor(id: 10, nome: 'Lombinho', preco: 30),
    Sabor(id: 11, nome: 'Portuguesa', preco: 30),
    Sabor(id: 12, nome: 'Presunto', preco: 30),
    Sabor(id: 13, nome: 'Romeu e Julieta', preco: 30),

    Sabor(id: 14, nome: 'Atum', preco: 35),
    Sabor(id: 15, nome: 'Atum com Catupiry', preco: 35),
    Sabor(id: 16, nome: 'Atum com Cheddar', preco: 35),
    Sabor(id: 17, nome: 'Bacon com Cheddar', preco: 35),
    Sabor(id: 18, nome: 'Bacon com Catupiry', preco: 35),
    Sabor(id: 19, nome: 'Calacheddar', preco: 35),
    Sabor(id: 20, nome: 'Calabacon', preco: 35),
    Sabor(id: 21, nome: 'Frango com Catupiry', preco: 35),
    Sabor(id: 22, nome: 'Frango com Cheddar', preco: 35),
    Sabor(id: 23, nome: 'Frango com Palha', preco: 35),
    Sabor(id: 24, nome: 'Frango com Milho', preco: 35),
    Sabor(id: 25, nome: 'Franbacon', preco: 35),
    Sabor(id: 26, nome: 'Mexicana', preco: 35),
    Sabor(id: 27, nome: 'Moda da Casa', preco: 35),
    Sabor(id: 28, nome: 'Peito de Peru', preco: 35),
    Sabor(id: 29, nome: '3 Queijos', preco: 35),

    Sabor(id: 30, nome: 'Carne Seca', preco: 40),
    Sabor(id: 31, nome: 'Pepperoni', preco: 40),
    Sabor(id: 32, nome: '4 Queijos', preco: 40),
  ];

  static const extras = [
    Extra(id: 1, nome: 'Coca Cola', categoria: 'BEBIDA', preco: 7),
    Extra(id: 2, nome: 'Guaraná', categoria: 'BEBIDA', preco: 7),

    Extra(id: 4, nome: 'Morango', categoria: 'GELADINHO', preco: 5),
    Extra(id: 5, nome: 'Chocolate', categoria: 'GELADINHO', preco: 5),
    Extra(id: 6, nome: 'Prestígio', categoria: 'GELADINHO', preco: 5),
    Extra(id: 7, nome: 'Ninho Com Nutella', categoria: 'GELADINHO', preco: 5),
    Extra(id: 9, nome: 'Morango Com Nutella', categoria: 'GELADINHO', preco: 5),
    Extra(id: 8, nome: 'Ninho Com Morango', categoria: 'GELADINHO', preco: 5),

    Extra(id: 7, nome: 'Maracujá', categoria: 'MOUSSE', preco: 6),
    Extra(id: 8, nome: 'Limão', categoria: 'MOUSSE', preco: 6),
    Extra(id: 9, nome: 'Morango', categoria: 'MOUSSE', preco: 6),
  ];
}
