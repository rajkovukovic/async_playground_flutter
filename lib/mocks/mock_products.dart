import 'dart:async';
import 'dart:math';

import 'package:async_playground_flutter/mocks/mock_baskets.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/utils/delays.dart';
import 'package:rxdart/rxdart.dart';

/// list of ten mock retail products of type Product
var initialMockProducts = [
  Product(name: 'Lamp', price: 100, stock: 20),
  Product(name: 'Chair', price: 50, stock: 10),
  Product(name: 'Sofa', price: 200, stock: 5),
  Product(name: 'Bed', price: 300, stock: 3),
  Product(name: 'Dining Table', price: 250, stock: 4),
  Product(name: 'TV Stand', price: 120, stock: 6),
  Product(name: 'Bookshelf', price: 80, stock: 8),
  Product(name: 'Wardrobe', price: 180, stock: 7),
];

final mockProductsSubject = BehaviorSubject.seeded(initialMockProducts);

/// Timer that runs every N seconds to update the stock and price
/// of the products by using _initialProducts
void initMockProductChanges() {
  void performProductChanges([void _]) {
    final productsInStock =
        initialMockProducts.where((product) => product.stock > 0);
    // pick one product using random number generator
    final productIdToReduceStock = productsInStock
        .elementAt(DateTime.now().millisecond % productsInStock.length)
        .id;
    final randomNumberGenerator = Random();

    final products = initialMockProducts.map((product) {
      final newStock = productIdToReduceStock == product.id
          ? product.stock - 1
          : product.stock;
      final newPrice =
          product.price + (randomNumberGenerator.nextInt(5) - 10) / 2;
      return Product(
        id: product.id,
        name: product.name,
        price: newPrice,
        stock: newStock,
      );
    }).toList();
    mockProductsSubject.add(products);

    /// update baskets with new product prices and stocks
    mockBasketSubject.add(mockBasketSubject.value
        .map((key, order) => MapEntry(key, order.updateProducts(products))));

    Future.delayed(productUpdateInterval(), performProductChanges);
  }

  Future.delayed(productUpdateInterval(), performProductChanges);
}
