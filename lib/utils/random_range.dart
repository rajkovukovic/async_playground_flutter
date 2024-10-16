import 'dart:math';

int randomRangeInt(int min, int max) {
  final random = Random();
  return min + ((max - min) * random.nextDouble()).round();
}
