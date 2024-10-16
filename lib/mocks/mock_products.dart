import 'dart:async';
import 'dart:math';

import 'package:async_playground_flutter/models/product.dart';
import 'package:rxdart/rxdart.dart';

/// list of ten mock retail products of type Product
var initialMockProducts = [
  Product(name: 'Lamp', price: 100, stock: 20),
  Product(name: 'Chair', price: 50, stock: 10),
  Product(name: 'Sofa', price: 200, stock: 5),
  Product(name: 'Bed', price: 300, stock: 3),
  Product(name: 'Cupboard', price: 150, stock: 2),
  Product(name: 'Dining Table', price: 250, stock: 4),
  Product(name: 'TV Stand', price: 120, stock: 6),
  Product(name: 'Bookshelf', price: 80, stock: 8),
  Product(name: 'Wardrobe', price: 180, stock: 7),
];

final mockProductsSubject = BehaviorSubject.seeded(initialMockProducts);

/// Timer that runs every 5 seconds to update the stock and price
/// of the products by using _initialProducts
final mockProductsUpdated = Timer.periodic(
  const Duration(seconds: 5),
  (timer) {
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
          product.price + (randomNumberGenerator.nextInt(50) - 100) / 10;
      return Product(
        id: product.id,
        name: product.name,
        price: newPrice,
        stock: newStock,
      );
    }).toList();
    mockProductsSubject.add(products);
  },
);
