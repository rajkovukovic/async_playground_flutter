import 'package:flutter/material.dart';

class ListTileWithPrice extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? price;
  final Color? tileColor;
  final GestureTapCallback? onTap;

  const ListTileWithPrice({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.tileColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: tileColor,
      title: Row(children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (price != null) Text('  \$$price'),
      ]),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
    );
  }
}
