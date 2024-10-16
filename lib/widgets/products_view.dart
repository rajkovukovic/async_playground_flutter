import 'package:async_playground_flutter/models/product.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A stateless widget that displays a list of products or a selected product's details.
/// If [selectedProduct] is null, it shows a list of products with name, price, and an "Add" button.
/// If [selectedProduct] is provided, it shows that product's details with a back button and an "Add to basket" option.
/// Handles product selection, deselection, and adding to the basket via [onProductSelected], [onProductDeselected], and [onProductAdded] callbacks.
/// Shows a loading animation for products in [pendingItems].
class ProductsView extends StatelessWidget {
  final List<Product> products;
  final Product? selectedProduct;
  final Set<String> pendingItems;
  final bool pending;
  final Function(Product)? onProductSelected;
  final Function()? onProductDeselected;
  final Function(Product)? onProductAdded;

  const ProductsView({
    super.key,
    required this.products,
    this.selectedProduct,
    this.pendingItems = const {},
    this.pending = false,
    this.onProductSelected,
    this.onProductDeselected,
    this.onProductAdded,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedProduct != null) {
      return SandwichView(
        header: ListTileWithPrice(
          title: selectedProduct!.name,
          price: selectedProduct!.price,
          tileColor: Colors.deepPurple.shade100,
          leading: IconButton(
            onPressed: onProductDeselected,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        footer: ListTileWithPrice(
          title: 'Add to basket',
          onTap: () => onProductAdded?.call(selectedProduct!),
          pending: pendingItems.contains(selectedProduct!.id),
        ),
        body: Text(selectedProduct!.description ?? ''),
      );
    }

    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Products',
        tileColor: Colors.deepPurple.shade100,
        pending: pending,
      ),
      items: products,
      itemBuilder: (context, product, index) => ListTileWithPrice(
        title: product.name,
        price: product.price,
        leading: IconButton(
          onPressed: () => onProductAdded?.call(product),
          icon: pendingItems.contains(product.id)
              ? LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.deepPurple,
                  size: 20,
                )
              : const Icon(Icons.add),
        ),
        onTap: () => onProductSelected?.call(product),
      ),
    );
  }
}
