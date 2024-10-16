import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/services/bank_service.dart';
import 'package:async_playground_flutter/services/basket_service.dart';
import 'package:async_playground_flutter/services/order_service.dart';
import 'package:async_playground_flutter/services/product_service.dart';
import 'package:async_playground_flutter/widgets/auth_view.dart';
import 'package:async_playground_flutter/widgets/bank_statement_view.dart';
import 'package:async_playground_flutter/widgets/basket_view.dart';
import 'package:async_playground_flutter/widgets/orders_view.dart';
import 'package:async_playground_flutter/widgets/products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  void showProductDetails(Product? product) {
    throw UnimplementedError();
  }

  void showOrderDetails(Order? order) {
    throw UnimplementedError();
  }

  void handleAddToBasket(Product product) {
    throw UnimplementedError();
  }

  void handleRemoveFromBasket(Product product) {
    throw UnimplementedError();
  }

  void handlePlaceOrder() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AuthView(users: mockUsers, authUserId: null),
      ),
      body: LayoutGrid(
        areas: '''
          products basket
          orders   bank
        ''',
        columnSizes: [1.fr, 1.fr],
        rowSizes: [
          1.fr,
          1.fr,
        ],
        children: [
          ProductsView(
            pending: false,
            pendingItems: const {},
            products: const [],
            selectedProduct: null,
            onProductAdded: handleAddToBasket,
            onProductSelected: showProductDetails,
            onProductDeselected: () => showProductDetails(null),
          ).inGridArea('products', key: const ValueKey('products')),
          BasketView(
            pending: false,
            pendingItems: const {},
            basket: null,
            onPlaceOrderPressed: handlePlaceOrder,
            onItemRemoved: (orderItem) =>
                handleRemoveFromBasket(orderItem.product),
          ).inGridArea('basket', key: const ValueKey('basket')),
          OrdersView(
            pending: false,
            orders: const [],
            selectedOrder: null,
            onOrderSelected: showOrderDetails,
            onOrderDeselected: (_) => showOrderDetails(null),
          ).inGridArea('orders', key: const ValueKey('orders')),
          BankStatementView(
            pending: false,
            bankStatement: null,
          ).inGridArea('bank', key: const ValueKey('bank')),
        ],
      ),
    );
  }
}
