import 'package:flutter/material.dart';

/// SandwichView takes body as widget, header and footer as optional widgets
/// and renders all in a card
class SandwichView extends StatelessWidget {
  final Widget body;
  final Widget? header;
  final Widget? footer;

  const SandwichView({
    super.key,
    required this.body,
    this.header,
    this.footer,
  });

  static Widget withList<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index)
        itemBuilder,
    Widget? header,
    Widget? footer,
  }) =>
      SandwichView(
        body: ListView.builder(
            itemBuilder: (context, index) => itemBuilder(
                  context,
                  items[index],
                  index,
                ),
            itemCount: items.length),
        header: header,
        footer: footer,
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header!,
          Expanded(child: body),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
