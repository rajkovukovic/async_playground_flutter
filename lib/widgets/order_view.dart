import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

/// OrderView displays order id and total on top
/// and all items and quantities in the order as a scrollable list bellow
class OrderView extends StatelessWidget {
  final Order order;
  final Function()? onBackPressed;

  const OrderView({super.key, required this.order, this.onBackPressed});

  @override
  Widget build(Object context) {
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'Order: ${order.id}',
        tileColor: Colors.deepPurple.shade100,
      ),
      items: order.items,
      itemBuilder: (context, item, index) => ListTileWithPrice(
        title: '${item.quantity}x ${item.product.name}',
        price: item.product.price,
        onTap: () => {},
      ),
    );
  }
}
