import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/models/order_item.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A stateless widget displaying the contents of a basket.
/// Shows the basket's items, with an option to remove items or place an order.
/// The header displays 'Empty Basket' if there are no items, or 'My Basket' otherwise.
/// Footer provides an option to place the order.
/// If an item is being removed (in [pendingItems]), a loading animation is shown instead of the remove icon.
/// Handles item removal via [onItemRemoved] and order placement via [onPlaceOrderPressed] callbacks.
class BasketView extends StatelessWidget {
  final Order? basket;
  final bool pending;
  final Set<String> pendingItems;
  final Function(OrderItem orderItem)? onItemRemoved;
  final Function()? onPlaceOrderPressed;

  const BasketView({
    super.key,
    required this.basket,
    this.pending = false,
    this.pendingItems = const {},
    this.onPlaceOrderPressed,
    this.onItemRemoved,
  });

  @override
  Widget build(Object context) {
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: basket == null || basket!.itemCount == 0
            ? 'Empty Basket'
            : 'My Basket',
        tileColor: Colors.deepPurple.shade100,
        pending: pending,
      ),
      footer: ListTileWithPrice(
        title: 'Place Order',
        price: basket?.total,
        onTap: onPlaceOrderPressed,
      ),
      items: basket?.items ?? [],
      itemBuilder: (context, orderItem, index) => ListTileWithPrice(
        title: '${orderItem.quantity}x ${orderItem.product.name}',
        price: orderItem.product.price,
        leading: IconButton(
          onPressed: () => onItemRemoved?.call(orderItem),
          icon: pendingItems.contains(orderItem.product.id)
              ? LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.deepPurple,
                  size: 20,
                )
              : const Icon(Icons.remove),
        ),
      ),
    );
  }
}
