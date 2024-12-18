import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/utils/delays.dart';
import 'package:async_playground_flutter/models/coming_soon.dart';

class OrderService {
  static ComingSoon<Order?> getOrderById(String orderId) {
    return ComingSoon<Order?>((resolve, reject) {
      Future.delayed(apiCallDuration(), () {
        final order = mockOrdersSubject.value
            .where((order) => order.id == orderId)
            .firstOrNull;

        if (order != null) {
          resolve(order);
        } else {
          reject('Order not found');
        }
      });
    });
  }

  static ComingSoon<List<Order>> getOrders(String userId) {
    return ComingSoon<List<Order>>((resolve, reject) {
      Future.delayed(apiCallDuration(), () {
        final orders = mockOrdersSubject.value
            .where((order) => order.userId == userId)
            .map((order) => order.withoutItems())
            .toList();

        if (orders.isNotEmpty) {
          resolve(orders);
        } else {
          reject('No orders found for this user');
        }
      });
    });
  }
}
