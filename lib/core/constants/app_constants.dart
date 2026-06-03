class AppConstants {
  static const basePizzaPrice = 35.0;
  static const deliveryFee = 5.0;
  static const minPizzas = 1;
  static const maxPizzas = 20;
  static const minAddressLength = 5;
  static const maxClienteNomeLength = 80;
  static const storeName = 'PIZZARIA';
}

enum OrderType { retirada, entrega }

enum ExtraCategory { bebida, geladinho, mousse }

extension OrderTypeLabel on OrderType {
  String get label => this == OrderType.retirada ? 'Retirada' : 'Entrega';

  String get dbValue => this == OrderType.retirada ? 'RETIRADA' : 'ENTREGA';

  static OrderType fromDb(String value) =>
      value == 'ENTREGA' ? OrderType.entrega : OrderType.retirada;
}

extension ExtraCategoryLabel on ExtraCategory {
  String get label {
    switch (this) {
      case ExtraCategory.bebida:
        return 'Bebidas';
      case ExtraCategory.geladinho:
        return 'Geladinhos';
      case ExtraCategory.mousse:
        return 'Mousses';
    }
  }

  String get dbValue {
    switch (this) {
      case ExtraCategory.bebida:
        return 'BEBIDA';
      case ExtraCategory.geladinho:
        return 'GELADINHO';
      case ExtraCategory.mousse:
        return 'MOUSSE';
    }
  }

  static ExtraCategory fromDb(String value) {
    switch (value) {
      case 'GELADINHO':
        return ExtraCategory.geladinho;
      case 'MOUSSE':
        return ExtraCategory.mousse;
      default:
        return ExtraCategory.bebida;
    }
  }
}
