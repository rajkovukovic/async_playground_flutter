import 'package:flutter/material.dart';

/// PendingBuilder has pending, error and builder parameters
/// If pending is true, a loader is displayed in the center
/// If error is not null, an error message is displayed
/// Otherwise, the builder function is called
class PendingBuilder<T> extends StatelessWidget {
  final bool pending;
  final String? error;
  final Widget Function() builder;

  const PendingBuilder({
    super.key,
    required this.pending,
    this.error,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (pending) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    return builder();
  }
}
