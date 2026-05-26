import '../../modules/catalog/models/extra.dart';
import '../../modules/catalog/models/sabor.dart';

class SeedData {
  static const sabores = [
    Sabor(id: 1, nome: 'Calabresa', preco: 0),
    Sabor(id: 2, nome: 'Portuguesa', preco: 0),
    Sabor(id: 3, nome: 'Frango Catupiry', preco: 0),
    Sabor(id: 4, nome: 'Quatro Queijos', preco: 0),
    Sabor(id: 5, nome: 'Moda da Casa', preco: 0),
    Sabor(id: 6, nome: 'Bacon', preco: 0),
  ];

  static const extras = [
    Extra(id: 1, nome: 'Coca Cola', categoria: 'BEBIDA', preco: 5),
    Extra(id: 2, nome: 'Guaraná', categoria: 'BEBIDA', preco: 5),
    Extra(id: 3, nome: 'Água', categoria: 'BEBIDA', preco: 3),
    Extra(id: 4, nome: 'Morango', categoria: 'GELADINHO', preco: 4),
    Extra(id: 5, nome: 'Chocolate', categoria: 'GELADINHO', preco: 4),
    Extra(id: 6, nome: 'Coco', categoria: 'GELADINHO', preco: 4),
    Extra(id: 7, nome: 'Maracujá', categoria: 'MOUSSE', preco: 6),
    Extra(id: 8, nome: 'Limão', categoria: 'MOUSSE', preco: 6),
    Extra(id: 9, nome: 'Chocolate', categoria: 'MOUSSE', preco: 6),
  ];
}
