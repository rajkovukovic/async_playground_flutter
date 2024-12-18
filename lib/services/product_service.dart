import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/utils/delays.dart';
import 'package:async_playground_flutter/models/coming_soon.dart';

class ProductService {
  static ComingSoon<Product?> getProductById(String productId) {
    return ComingSoon<Product?>((resolve, reject) {
      Future.delayed(apiCallDuration(), () {
        final product = mockProductsSubject.value
            .where((product) => product.id == productId)
            .firstOrNull;

        if (product != null) {
          resolve(product);
        } else {
          reject('Product not found');
        }
      });
    });
  }

  /// Returns the products without description using ComingSoon
  static ComingSoon<List<Product>> getProducts() {
    return ComingSoon<List<Product>>((resolve, reject) {
      Future.delayed(apiCallDuration(), () {
        final products = mockProductsSubject.value
            .map((product) => product.withoutDescription())
            .toList();

        if (products.isNotEmpty) {
          resolve(products);
        } else {
          reject('No products found');
        }
      });
    });
  }
}
