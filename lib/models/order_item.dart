import 'product.dart';

/// OrderItem model has product and quantity and a total getter
class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  double get total => product.price * quantity;

  OrderItem copyWith({Product? product, int? quantity}) {
    return OrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
