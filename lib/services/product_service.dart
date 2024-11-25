import 'package:async_playground_flutter/mocks/mock_products.dart';
import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/types/callback.dart';
import 'package:async_playground_flutter/types/coming_soon.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class ProductService {
  /// Returns the product by id
  static void getProductByIdCallback(
    String productId,
    Callback<Product?> callback,
  ) {
    Future.delayed(apiCallDuration(), () {
      callback(
        null,
        mockProductsSubject.value
            .where((product) => product.id == productId)
            .firstOrNull,
      );
    });
  }

  static ComingSoon<List<Product>>? getProductsComingSoon() {
    ComingSoon<List<Product>>? res = ComingSoon();
    getProductsCallback(
      (error, products) {
        if (products != null) {
          res.resolve(products);
        } else {
          res.reject(error ?? 'No products');
        }
      },
    );
    return res;
  }

  /// Returns the products without description
  static void getProductsCallback(Callback<List<Product>> callback) {
    Future.delayed(apiCallDuration(), () {
      callback(
          null,
          mockProductsSubject.value
              .map((product) => product.withoutDescription())
              .toList());
    });
  }
}
