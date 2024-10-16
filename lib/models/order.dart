import 'package:async_playground_flutter/models/product.dart';

import 'order_item.dart';

/// Order model has id, userId and a list of OrderItem
/// and a getter to calculate total
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  int itemCount;
  double total;

  Order({
    String? id,
    required this.userId,
    required this.items,
    double? total,
    int? itemCount,
  })  : id = id ?? 'O-${++_counter}',
        total = total ?? items.fold(0, (total, item) => total + item.total),
        itemCount =
            itemCount ?? items.fold(0, (count, item) => count + item.quantity);

  static var _counter = 0;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Order copyWith({String? id, String? userId, List<OrderItem>? items}) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
    );
  }

  bool get isEmpty => items.isEmpty && itemCount == 0;

  Order updateProducts(List<Product> products) {
    final updatedItems = items.map((item) {
      final product =
          products.firstWhere((product) => product.id == item.product.id);
      return item.copyWith(product: product);
    }).toList();
    return Order(id: id, userId: userId, items: updatedItems);
  }

  Order withoutItems() {
    return Order(
      id: id,
      userId: userId,
      total: total,
      itemCount: itemCount,
      items: [],
    );
  }
}
