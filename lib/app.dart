import 'package:async_playground_flutter/mocks/mock_bank_statements.dart';
import 'package:async_playground_flutter/mocks/mock_orders.dart';
import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/widgets/auth_view.dart';
import 'package:async_playground_flutter/widgets/bank_statement_view.dart';
import 'package:async_playground_flutter/widgets/basket_view.dart';
import 'package:async_playground_flutter/widgets/order_view.dart';
import 'package:async_playground_flutter/widgets/orders_view.dart';
import 'package:async_playground_flutter/widgets/products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final products = mockProductsSubject.value;
    final basket = mockOrdersSubject.value.first;
    final orders = mockOrdersSubject.value;
    final bankStatement = mockBankStatementsSubject.value.first;

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: AuthView(users: mockUsers),
      ),
      body: LayoutGrid(
        // ASCII-art named areas 🔥
        areas: '''
          products basket
          orders   bank
        ''',
        // Concise track sizing extension methods 🔥
        columnSizes: [1.fr, 1.fr],
        rowSizes: [
          1.fr,
          1.fr,
        ],
        // Handy grid placement extension methods on Widget 🔥
        children: [
          ProductsView(products: products).inGridArea('products'),
          BasketView(basket: basket).inGridArea('basket'),
          OrdersView(orders: orders).inGridArea('orders'),
          BankStatementView(bankStatement: bankStatement).inGridArea('bank'),
        ],
      ),
    );
  }
}
