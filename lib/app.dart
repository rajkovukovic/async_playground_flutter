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
import 'package:async_playground_flutter/types/coming_soon.dart';
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
  List<Product>? products;

  // User
  User? loggedInUser;
  Product? selectedProduct;
  Order? basket;
  List<Order> orders = [];
  Order? selectedOrder;
  bool pendingOrderDetails = false;
  bool pendingBasket = false;
  BankStatement? bankStatement;

  Set<String> pendingProducts = {};

  void showProductDetails(Product? product) {
    if (product != null) {
      pendingProducts.add(product.id);
      setState(() {});
      ProductService.getProductByIdCallback(
        product.id,
        (error, result) {
          selectedProduct = result;
          result != null ? pendingProducts.remove(result.id) : null;
          setState(() {});
        },
      );
    } else {
      selectedProduct = null;
      setState(() {});
    }
    throw UnimplementedError('showProductDetails');
  }

  void showOrderDetails(Order? order) {
    pendingOrderDetails = true;
    setState(() {});
    if (order != null) {
      OrderService.getOrderByIdCallback(order.id, (error, res) {
        selectedOrder = res;
        pendingOrderDetails = false;
        setState(() {});
      });
    } else {
      pendingOrderDetails = false;
      selectedOrder = null;
      setState(() {});
    }

    throw UnimplementedError('showOrderDetails');
  }

  void handleAddToBasket(Product product) {
    pendingProducts.add(product.id);

    pendingBasket = true;
    setState(() {});
    if (loggedInUser != null) {
      BasketService.upsertBasketCallback(
        loggedInUser!.id,
        product,
        1,
        (error, order) {
          if (order != null) {
            basket = order;
            pendingProducts.remove(product.id);
            pendingBasket = false;
            setState(() {});
          }
        },
      );
    } else {
      pendingProducts.remove(product.id);
      pendingBasket = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'User must be logged in to make orders !!!',
          style: TextStyle(fontSize: 32),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ));
    }
    pendingProducts.remove(product.id);
    setState(() {});
    // throw UnimplementedError('handleAddToBasket');
  }

  void handleRemoveFromBasket(Product product) {
    pendingBasket = false;
    setState(() {});
    BasketService.removeFromBasketCallback(
      loggedInUser!.id,
      product.id,
      (error, result) {
        basket = result;
        pendingBasket = false;
        setState(() {});
      },
    );
  }

  void handlePlaceOrder() {
    if (basket != null && loggedInUser != null) {
      BasketService.placeOrderFromBasketCallback(loggedInUser!.id,
          (error, result) {
        if (result != null) {
          OrderService.getOrdersCallback(loggedInUser!.id, (error, res) {
            if (res != null) {
              orders = res;
              basket = null;
              setState(() {});
            }
          });
        }
      });

      setState(() {});
    } else {
      throw UnimplementedError('basket is Empty or user not logged in');
    }
  }

  @override
  void didUpdateWidget(covariant App oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _fetchProducts() async {
    ComingSoon test = ProductService.getProductsComingSoon();

    thenCallback(value) {
      print('zika $value');
    }

    await Future.delayed(
      const Duration(seconds: 2),
    );
    test.then(thenCallback); // 300ms

    ProductService.getProductsCallback(
      (error, result) {
        if (result != null && result.isNotEmpty) {
          products = result;
          _alignSelectedProduct();

          if (loggedInUser != null) {
            _alignBasket();

            OrderService.getOrdersCallback(loggedInUser!.id, (error, res) {
              if (res != null) {
                orders = res;
              }
            });

            BankService.getStatementCallback(loggedInUser!.id, (e, r) {
              bankStatement = r;
            });
          }
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    _fetchProducts();
    Timer.periodic(const Duration(seconds: 60), (t) => _fetchProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AuthView(
          users: mockUsers,
          authUserId: loggedInUser?.id,
          onUserSignedIn: (user) {
            if (loggedInUser?.id != user.id) {
              AuthService.loginCallback(
                user.id,
                (error, result) {
                  loggedInUser = result;
                  OrderService.getOrdersCallback(loggedInUser!.id,
                      (error, res) {
                    if (res != null) {
                      orders = res;
                      basket = null;
                      // setState(() {});
                    }
                  });
                  _reset();
                  setState(() {});
                },
              );
            }
          },
          onUserSignedOut: (p0) {
            if (loggedInUser?.id == p0.id) {
              loggedInUser = null;
              _reset();
              setState(() {});
            }
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
            pending: false,
            pendingItems: pendingProducts,
            products: products ?? [],
            selectedProduct: selectedProduct,
            onProductAdded: (pr) => handleAddToBasket(pr),
            onProductSelected: (pr) => showProductDetails(pr),
            onProductDeselected: () => showProductDetails(null),
          ).inGridArea('products', key: const ValueKey('products')),
          BasketView(
            pending: pendingBasket,
            pendingItems: pendingProducts,
            basket: basket,
            onPlaceOrderPressed: handlePlaceOrder,
            onItemRemoved: (orderItem) =>
                handleRemoveFromBasket(orderItem.product),
          ).inGridArea('basket', key: const ValueKey('basket')),
          OrdersView(
            pending: pendingOrderDetails,
            orders: orders,
            selectedOrder: selectedOrder,
            onOrderSelected: showOrderDetails,
            onOrderDeselected: (_) => showOrderDetails(null),
          ).inGridArea('orders', key: const ValueKey('orders')),
          BankStatementView(
            pending: false,
            bankStatement: bankStatement,
          ).inGridArea('bank', key: const ValueKey('bank')),
        ],
      ),
    );
  }

  _alignSelectedProduct() {
    if (selectedProduct != null) {
      selectedProduct = products
          ?.where(
            (element) => element.id == selectedProduct!.id,
          )
          .firstOrNull;
    }
  }

  _alignBasket() async {
    if (loggedInUser != null) {
      pendingBasket = true;
      setState(() {});

      BasketService.getBasketCallback(
        loggedInUser!.id,
        (error, order) {
          basket = order;
          pendingBasket = false;
          setState(() {});
        },
      );
    }
  }

  _reset() {
    selectedProduct = null;
    basket = null;
    orders = [];
    setState(() {});
  }
}
