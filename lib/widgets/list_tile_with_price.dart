import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A stateless widget that displays a title, optional subtitle, and a price.
/// Can show a loading animation when [pending] is true.
/// Optionally supports custom [leading] and [trailing] widgets.
/// Handles tap events via the [onTap] callback.
/// The tile's background color can be set using [tileColor].
class ListTileWithPrice extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? price;
  final Color? tileColor;
  final Widget? leading;
  final Widget? trailing;
  final bool pending;
  final GestureTapCallback? onTap;

  const ListTileWithPrice({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.tileColor,
    this.leading,
    this.trailing,
    this.pending = false,
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
        const SizedBox(width: 16),
        if (pending)
          LoadingAnimationWidget.waveDots(
            color: Colors.deepPurple,
            size: 30,
          ),
      ]),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
      leading: leading,
      trailing: trailing,
    );
  }
}
