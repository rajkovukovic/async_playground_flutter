import 'package:async_playground_flutter/models/order.dart';
import 'package:async_playground_flutter/widgets/list_tile_with_price.dart';
import 'package:async_playground_flutter/widgets/sandwich_view.dart';
import 'package:flutter/material.dart';

class BasketView extends StatelessWidget {
  final Order basket;
  final Function()? onPlacePressed;

  const BasketView({super.key, required this.basket, this.onPlacePressed});

  @override
  Widget build(Object context) {
    return SandwichView.withList(
      header: ListTileWithPrice(
        title: 'My Basket',
        tileColor: Colors.deepPurple.shade100,
      ),
      footer: ListTileWithPrice(
        title: 'Place Order',
        tileColor: Colors.deepPurple.shade100,
        onTap: () {},
      ),
      items: basket.items,
      itemBuilder: (context, item, index) => ListTileWithPrice(
        title: '${item.quantity}x ${item.product.name}',
        price: item.product.price,
        onTap: () => {},
      ),
    );
  }
}
