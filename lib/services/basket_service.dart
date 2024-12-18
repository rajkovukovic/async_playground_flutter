import 'package:async_playground_flutter/models/coming_soon.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/expense.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/order_item.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/mocks/mock_baskets.dart';
import 'package:async_playground_flutter/mocks/mock_bank_statements.dart';
import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class BasketService {
  /// Get the basket for the user
  static ComingSoon<Order?> getBasketCallback(String userId) {
    return ComingSoon<Order?>((resolve, reject) {
      // Simulate the delay for the API call
      Future.delayed(apiCallDuration(), () {
        _updateBasketsWithLatestProducts();
        final basket = mockBasketSubject.value[userId];
        resolve(basket); // Resolve with the basket or null if not found
      });
    });
  }

  /// Insert or Update product in the basket
  static ComingSoon<Order> upsertBasketCallback(
    String userId,
    Product product,
    int quantity,
  ) {
    return ComingSoon<Order>((resolve, reject) {
      // Simulate the delay for the API call
      Future.delayed(apiCallDuration(), () {
        final order =
            mockBasketSubject.value[userId] ?? Order(items: [], userId: userId);
        final updatedOrder = order.copyWith(
          items: [
            ...order.items.where((item) => item.product.id != product.id),
            OrderItem(product: product, quantity: quantity),
          ],
        );
        mockBasketSubject.value[userId] = updatedOrder;
        mockBasketSubject.add(mockBasketSubject.value);
        _updateBasketsWithLatestProducts();
        resolve(updatedOrder); // Resolve with the updated order
      });
    });
  }

  /// Remove product from the basket
  static ComingSoon<Order> removeFromBasketCallback(
    String userId,
    String productId,
  ) {
    return ComingSoon<Order>((resolve, reject) {
      // Simulate the delay for the API call
      Future.delayed(apiCallDuration(), () {
        final order = mockBasketSubject.value[userId];
        if (order == null) {
          reject(
              'Basket not found'); // Reject with an error if the basket is not found
        } else {
          final updatedItems = order.items
              .where((item) => item.product.id != productId)
              .toList();
          final updatedOrder = order.copyWith(items: updatedItems);
          mockBasketSubject.value[userId] = updatedOrder;
          mockBasketSubject.add(mockBasketSubject.value);
          _updateBasketsWithLatestProducts();
          resolve(updatedOrder); // Resolve with the updated order
        }
      });
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
  static ComingSoon<Order> placeOrderFromBasketCallback(String userId) {
    return ComingSoon<Order>((resolve, reject) {
      // Simulate the delay for the API call
      Future.delayed(apiCallDuration(), () {
        final order = mockBasketSubject.value[userId];
        if (order == null || order.isEmpty) {
          reject('Basket is empty'); // Reject if the basket is empty
        } else {
          // Update basket
          mockBasketSubject.value.remove(userId);
          mockBasketSubject.add(mockBasketSubject.value);
          // Update orders
          mockOrdersSubject.add([...mockOrdersSubject.value, order]);
          // Update bank statements
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
                date: DateTime.now()
                    .subtract(const Duration(days: 1, minutes: 30)),
              ),
            ],
          );
          mockBankStatementsSubject.add({
            ...mockBankStatementsSubject.value,
            userId: updatedStatement,
          });
          resolve(order); // Resolve with the placed order
        }
      });
    });
  }
}
