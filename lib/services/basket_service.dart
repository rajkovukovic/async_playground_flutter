import 'package:async_playground_flutter/mocks/mock_bank_statements.dart';
import 'package:async_playground_flutter/mocks/mock_baskets.dart';
import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/expense.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/order_item.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/types/callback.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class BasketService {
  /// Get the basket for the user
  static void getBasketCallback(
    String userId,
    Callback<Order?> callback,
  ) {
    Future.delayed(apiCallDuration(), () {
      _updateBasketsWithLatestProducts();
      callback(null, mockBasketSubject.value[userId]);
    });
  }

  /// Insert or Update product in the basket
  static void upsertBasketCallback(
    String userId,
    Product product,
    int quantity,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration(), () {
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
      _updateBasketsWithLatestProducts();
      callback(null, mockBasketSubject.value[userId]);
    });
  }

  /// Remove product from the basket
  static void removeFromBasketCallback(
    String userId,
    String productId,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration(), () {
      final order = mockBasketSubject.value[userId];
      if (order == null) {
        return callback('Basket not found', null);
      }
      final updatedItems =
          order.items.where((item) => item.product.id != productId).toList();
      final updatedOrder = order.copyWith(items: updatedItems);
      mockBasketSubject.value[userId] = updatedOrder;
      mockBasketSubject.add(mockBasketSubject.value);
      _updateBasketsWithLatestProducts();
      callback(null, mockBasketSubject.value[userId]);
    });
  }

  static _updateBasketsWithLatestProducts() {
    final baskets = mockBasketSubject.value;
    final productMap = {
      for (var product in mockProductsSubject.value) product.id: product
    };
    final updatedBaskets = baskets.map((basketKey, value) {
      final updatedItems = value.items.map((item) {
        final product = productMap[item.product.id] ?? item.product;
        return OrderItem(product: product, quantity: item.quantity);
      }).toList();
      return MapEntry(basketKey, value.copyWith(items: updatedItems));
    });
    mockBasketSubject.add(updatedBaskets);
  }

  /// Places order in basket for the user and removes all items from the basket
  /// Returns the order placed
  /// User's basket will be null after this call
  static void placeOrderFromBasketCallback(
    String userId,
    Callback<Order> callback,
  ) {
    Future.delayed(apiCallDuration(), () {
      final order = mockBasketSubject.value[userId];
      if (order == null || order.isEmpty) {
        return callback('Basket is empty', null);
      }
      // update basket
      mockBasketSubject.value.remove(userId);
      mockBasketSubject.add(mockBasketSubject.value);
      // update orders
      mockOrdersSubject.add([...mockOrdersSubject.value, order]);
      // update bank statements
      final bankStatement = mockBankStatementsSubject.value[userId] ??
          BankStatement(userId: userId, balance: 0, expenses: []);
      final updatedStatement = bankStatement.copyWith(
        balance: bankStatement.balance - order.total,
        expenses: [
          ...bankStatement.expenses,
          Expense(
            id: 'expense_${order.id}',
            amount: order.total,
            description: 'Order ${order.id}',
            date: DateTime.now().subtract(const Duration(days: 1, minutes: 30)),
          ),
        ],
      );
      mockBankStatementsSubject.add({
        ...mockBankStatementsSubject.value,
        userId: updatedStatement,
      });
      // callback
      callback(null, order);
    });
  }
}
