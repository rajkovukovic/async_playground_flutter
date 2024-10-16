import 'package:async_playground_flutter/mocks/mock_baskets.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/order_item.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/types/callback.dart';
import 'package:async_playground_flutter/utils/constants.dart';

class BasketService {
  /// Insert or Update product in the basket
  static void upsertBasketCallback(
    String userId,
    Product product,
    int quantity,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration, () {
      final order =
          (mockBasketSubject.value[userId] ?? Order(items: [], userId: userId));
      final updatedOrder = order.copyWith(
        items: [
          ...order.items.where((item) => item.product.id != product.id),
          OrderItem(product: product, quantity: quantity),
        ],
      );
      mockBasketSubject.value[userId] = updatedOrder;
      mockBasketSubject.add(mockBasketSubject.value);
      callback(null, mockBasketSubject.value[userId]);
    });
  }

  /// Remove product from the basket
  static void removeFromBasketCallback(
    String userId,
    String productId,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration, () {
      final order = mockBasketSubject.value[userId];
      if (order == null) {
        return callback('Basket not found', null);
      }
      final updatedItems =
          order.items.where((item) => item.product.id != productId).toList();
      final updatedOrder = order.copyWith(items: updatedItems);
      mockBasketSubject.value[userId] = updatedOrder;
      mockBasketSubject.add(mockBasketSubject.value);
      callback(null, mockBasketSubject.value[userId]);
    });
  }

  /// Get the basket for the user
  static void getBasketCallbackCallback(
    String userId,
    Callback<Order?> callback,
  ) {
    Future.delayed(apiCallDuration, () {
      callback(null, mockBasketSubject.value[userId]);
    });
  }
}
