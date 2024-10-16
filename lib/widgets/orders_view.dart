import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/order_view.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

/// OrdersView displays the list of orders
/// It takes List<Order> as input and displays OrderView for each order
/// each order is shows order id and total
/// if selectedOrder is provided, it will show OrderView for that order with a back button
class OrdersView extends StatelessWidget {
  final List<Order> orders;
  final Order? selectedOrder;
  final Function()? onSelectedOrderClosed;

  const OrdersView({
    super.key,
    required this.orders,
    this.selectedOrder,
    this.onSelectedOrderClosed,
  });

  @override
  Widget build(Object context) {
    if (selectedOrder != null) {
      return OrderView(
        order: selectedOrder!,
        onBackPressed: onSelectedOrderClosed,
      );
    }

    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Orders',
        tileColor: Colors.deepPurple.shade100,
      ),
      items: orders,
      itemBuilder: (context, order, index) => ListTileWithPrice(
        title: 'Order ${order.id}',
        price: order.total,
        onTap: () => onSelectedOrderClosed?.call(),
      ),
    );
  }
}
