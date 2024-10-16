import 'dart:math';

/// list extension radomElement returns a random element from the list
/// or throws an error if the list is empty
extension ListExtension<T> on List<T> {
  T get randomElement {
    if (isEmpty) {
      throw StateError('Cannot get random element from empty list');
    }
    return this[(_randomGenerator.nextDouble() * length).floor()];
  }
}

final _randomGenerator = Random();
