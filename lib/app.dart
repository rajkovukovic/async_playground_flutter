import 'dart:async';

import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/bank_statement.dart';
import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/models/user.dart';
import 'package:async_playground_flutter/services/auth_service.dart';
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
  bool pendingProd = false;
  bool pendingBasket = false;
  bool pendingOrders = false;
  bool pendingBank = false;

  List<Product> products = [];
  Product? selectedProduct;
  Set<String> pendingProducts = {};
  Set<String> pendingBasketProducts = {};
  Order? basket;
  Order? selectedOrder;
  List<Order> orders = [];
  User? loggedUser;
  BankStatement? bankStatement;

  String? then1;
  String? then2;
  String? then3;
  Object? error1;

  @override
  void initState() {
    super.initState();

    fetchProducts();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchProducts();
      fetchBankStatement(loggedUser);
      fetchBasket(loggedUser);
    });
  }

  void fetchProducts() {
    setState(() {
      pendingProd = true;
    });
    ProductService.getProducts().then((data) {
      setState(() {
        products = data;
      });
    }).catchError((error) {
      debugPrint('Error: $error');
    });
    setState(() {
      pendingProd = false;
    });
  }

  void showProductDetails(Product? product) {
    if (product != null) {
      ProductService.getProductById(product.id).then((product) {
        setState(() {
          selectedProduct = product;
        });
      }).catchError((error) {
        debugPrint('Error: $error');
      });
    } else {
      setState(() {
        selectedProduct = null;
      });
    }
  }

  void showOrderDetails(Order? order) {
    if (order != null) {
      OrderService.getOrderById(order.id).then((order) {
        setState(() {
          selectedOrder = order;
        });
      }).catchError((error) {
        debugPrint('Error: $error');
      });
    } else {
      setState(() {
        selectedOrder = null;
      });
    }
  }

  void handleAddToBasket(
    Product product,
  ) {
    if (loggedUser != null) {
      setState(() {
        pendingBasket = true;
        pendingProducts.add(product.id);
      });

      final quantity = basket?.items
              .where((item) => item.product.id == product.id)
              .firstOrNull
              ?.quantity ??
          0;

      BasketService.upsertBasketCallback(loggedUser!.id, product, quantity + 1)
          .then((data) {
        setState(() {
          basket = data;
          pendingProducts.remove(product.id);
          pendingBasket = false;
        });
      }).catchError((error) => debugPrint('Error:$error'));
    }
  }

  void handleRemoveFromBasket(Product product) {
    if (loggedUser != null) {
      setState(() {
        pendingBasketProducts.add(product.id);
      });

      BasketService.removeFromBasketCallback(loggedUser!.id, product.id)
          .then((data) {
        setState(() {
          basket = data;
          pendingBasketProducts.remove(product.id);
        });
      }).catchError((error) => debugPrint('Error:$error'));
    }
  }

  void handlePlaceOrder() {
    if (loggedUser != null) {
      BasketService.placeOrderFromBasketCallback(loggedUser!.id).then((data) {
        setState(() {
          basket = null;
          orders.add(data);
        });
      }).catchError((error) => debugPrint('Error:$error'));
    }
  }

  void fetchBankStatement(User? user) {
    if (user != null) {
      setState(() {
        pendingBank = true;
      });
      BankService.getStatementCallback(user.id).then((statement) {
        setState(() {
          bankStatement = statement;
        });
      }).catchError((error) {
        debugPrint('Error: $error');
      });
      setState(() {
        pendingBank = false;
      });
    }
  }

  void fetchBasket(User? user) {
    if (user != null) {
      setState(() {
        pendingBasket = true;
      });
      BasketService.getBasketCallback(user.id).then((value) {
        setState(() {
          basket = value;
        });
      }).catchError((error) {
        debugPrint('Error: $error');
      });

      setState(() {
        pendingBasket = false;
      });
    }
  }

  void fetchOrders(User? user) {
    if (user != null) {
      setState(() {
        pendingOrders = true;
      });
      OrderService.getOrders(user.id).then((value) {
        setState(() {
          orders = value;
        });
      }).catchError((error) {
        debugPrint('Error: $error');
      });
      setState(() {
        pendingOrders = false;
      });
    }
  }

  void logIn(User user) {
    logOut();

    AuthService.loginCallback(user.id).then((user) {
      setState(() {
        loggedUser = user;
      });
    }).then((val) {
      fetchBankStatement(loggedUser);
    }).then((val) {
      fetchBasket(loggedUser);
    }).then((val) {
      fetchOrders(loggedUser);
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }

  void logOut() {
    setState(() {
      loggedUser = null;
      orders = [];
      basket = null;
      bankStatement = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AuthView(
          users: mockUsers,
          authUserId: loggedUser?.id,
          onUserSignedIn: (user) {
            logIn(user);
          },
          onUserSignedOut: (user) {
            logOut();
          },
        ),
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
            pending: pendingProd,
            pendingItems: pendingProducts,
            products: products,
            selectedProduct: selectedProduct,
            onProductAdded: handleAddToBasket,
            onProductSelected: (product) => showProductDetails(product),
            onProductDeselected: () => showProductDetails(null),
          ).inGridArea('products', key: const ValueKey('products')),
          BasketView(
            pending: pendingBasket,
            pendingItems: pendingBasketProducts,
            basket: basket,
            onPlaceOrderPressed: handlePlaceOrder,
            onItemRemoved: (orderItem) =>
                handleRemoveFromBasket(orderItem.product),
          ).inGridArea('basket', key: const ValueKey('basket')),
          OrdersView(
            pending: pendingOrders,
            orders: orders,
            selectedOrder: selectedOrder,
            onOrderSelected: showOrderDetails,
            onOrderDeselected: (_) => showOrderDetails(null),
          ).inGridArea('orders', key: const ValueKey('orders')),
          BankStatementView(
            pending: pendingBank,
            bankStatement: bankStatement,
          ).inGridArea('bank', key: const ValueKey('bank')),
        ],
      ),
    );
  }
}
