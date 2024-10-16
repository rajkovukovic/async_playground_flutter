import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/order_item.dart';
import 'package:rxdart/subjects.dart';

final mockOrdersSubject = BehaviorSubject.seeded([
  Order(
    userId: '1',
    items: [OrderItem(product: initialMockProducts[2], quantity: 1)],
  ),
  Order(
    userId: '2',
    items: [OrderItem(product: initialMockProducts[5], quantity: 1)],
  ),
]);
