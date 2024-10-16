import 'package:async_playground_flutter/mocks/mock_baskets.dart';
import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/types/callback.dart';
import 'package:async_playground_flutter/utils/constants.dart';

class OrderService {
  /// Returns the orders by id
  static void getOrderByIdCallback(
    String orderId,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration, () {
      callback(
          null,
          mockOrdersSubject.value
              .where((order) => order.id == orderId)
              .firstOrNull);
    });
  }

  /// Returns the orders for the user (without items)
  static void getOrdersCallback(
    String userId,
    Callback<List<Order>> callback,
  ) {
    Future.delayed(apiCallDuration, () {
      callback(
          null,
          mockOrdersSubject.value
              .where((order) => order.userId == userId)
              .map((order) => order.withoutItems())
              .toList());
    });
  }

  /// Places order in basket for the user and removes all items from the basket
  static void placeOrderFromBasketCallback(
    String userId,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration, () {
      final order = mockBasketSubject.value[userId];
      if (order == null || order.isEmpty) {
        return callback('Basket is empty', null);
      }
      mockBasketSubject.value.remove(userId);
      mockBasketSubject.add(mockBasketSubject.value);
      mockOrdersSubject.add([...mockOrdersSubject.value, order]);
      callback(null, order);
    });
  }
}
