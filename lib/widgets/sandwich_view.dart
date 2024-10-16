import 'package:flutter/material.dart';

/// A stateless widget that renders a [body] inside a card, with optional [header] and [footer].
/// Displays the provided widgets in a vertical layout, with the body taking up the remaining space.
/// The static method [withList] allows rendering a list of items with custom item builders, along with optional header and footer.
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
