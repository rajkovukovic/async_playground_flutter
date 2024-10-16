import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

/// A stateless widget that displays a list of orders.
/// If [selectedOrder] is provided, it shows the details of that order with a back button.
/// Otherwise, it displays a list of orders, each showing its order ID and total price.
/// Handles order selection and deselection via [onOrderSelected] and [onOrderDeselected] callbacks.
class OrdersView extends StatelessWidget {
  final List<Order> orders;
  final Order? selectedOrder;
  final bool pending;
  final Function(Order? order)? onOrderSelected;
  final Function(Order? order)? onOrderDeselected;

  const OrdersView({
    super.key,
    required this.orders,
    this.selectedOrder,
    this.pending = false,
    this.onOrderSelected,
    this.onOrderDeselected,
  });

  @override
  Widget build(Object context) {
    if (selectedOrder != null) {
      /// If selectedOrder is provided, show OrderView for that order
      return SandwichView.withList(
        header: ListTileWithPrice(
          title: 'Order: ${selectedOrder!.id}',
          price: selectedOrder!.total,
          tileColor: Colors.deepPurple.shade100,
          leading: IconButton(
            onPressed: () => onOrderDeselected?.call(selectedOrder!),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        items: selectedOrder!.items,
        itemBuilder: (context, item, index) => ListTileWithPrice(
          title: '${item.quantity}x ${item.product.name}',
          price: item.product.price,
          onTap: () => {},
        ),
      );
    }

    /// If selectedOrder is not provided, show list of orders
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Orders',
        tileColor: Colors.deepPurple.shade100,
        pending: pending,
      ),
      items: orders,
      itemBuilder: (context, order, index) => ListTileWithPrice(
        title: 'Order ${order.id}',
        price: order.total,
        onTap: () => onOrderSelected?.call(order),
      ),
    );
  }
}
