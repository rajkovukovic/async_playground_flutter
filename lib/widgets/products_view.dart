import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

/// ProductsView is a stateless widget that takes list of products and
/// optional selectedProduct. If selectedProduct is null,
/// the list of products is displayed, with product name, price and a plus button
/// If selectedProduct is not null, the product details with name and price
/// are displayed with a back button on top
class ProductsView extends StatelessWidget {
  final List<Product> products;
  final Product? selectedProduct;
  final Function(Product)? onProductSelected;
  final Function()? onProductDeselected;
  final Function(Product)? onProductAdded;

  const ProductsView({
    super.key,
    required this.products,
    this.selectedProduct,
    this.onProductSelected,
    this.onProductDeselected,
    this.onProductAdded,
  });

  @override
  Widget build(BuildContext context) {
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Products',
        tileColor: Colors.deepPurple.shade100,
      ),
      items: products,
      itemBuilder: (context, product, index) => ListTileWithPrice(
        title: product.name,
        price: product.price,
        onTap: () => onProductSelected?.call(product),
      ),
    );
  }
}
