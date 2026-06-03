enum PaymentMethod { cartao, pix, dinheiro }

extension PaymentMethodLabel on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cartao:
        return 'Cartão';
      case PaymentMethod.pix:
        return 'Pix';
      case PaymentMethod.dinheiro:
        return 'Dinheiro';
    }
  }

  String get dbValue {
    switch (this) {
      case PaymentMethod.cartao:
        return 'CARTAO';
      case PaymentMethod.pix:
        return 'PIX';
      case PaymentMethod.dinheiro:
        return 'DINHEIRO';
    }
  }

  static PaymentMethod? fromDb(String value) {
    switch (value) {
      case 'CARTAO':
        return PaymentMethod.cartao;
      case 'PIX':
        return PaymentMethod.pix;
      case 'DINHEIRO':
        return PaymentMethod.dinheiro;
      default:
        return null;
    }
  }
}
