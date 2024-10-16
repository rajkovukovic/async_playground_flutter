import 'order_item.dart';

/// Order model has id, userId and a list of OrderItem
/// and a getter to calculate total
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;

  Order({String? id, required this.userId, required this.items}) : id = id ?? 'O-${_counter++}';

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

  int get itemCount => items.fold(0, (count, item) => count + item.quantity);

  double get total => items.fold(0, (total, item) => total + item.total);
}
