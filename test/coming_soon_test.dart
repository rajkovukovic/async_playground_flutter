import 'package:async_playground_flutter/models/coming_soon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ComingSoon tests', () {
    test('Chains multiple then calls with same type', () {
      var result = "";
      ComingSoon<String>(() => "Result")
          .then((value) => "$value -> Then 1")
          .then((value) => "$value -> Then 2")
          .then((value) => result = value);

      expect(result, equals("Result -> Then 1 -> Then 2"));
    });

    test('Chains multiple then calls with different types', () {
      String result = "";

      ComingSoon(() => 27)
          .then((value) => value.toDouble())
          .then((value) => "The value is $value")
          .then((value) => result = value);

      expect(result, equals("The value is 27.0"));
    });

    test('Catches error and invoke catchError callback', () {
      String errorMessage = "";
      final comingSoon = ComingSoon<int>(() {
        throw Exception('Test Error');
      });

      comingSoon.catchError((error) {
        errorMessage = error.toString();
        throw Exception(errorMessage);
      });

      expect(errorMessage, 'Exception: Test Error');
    });

    test('Catches error and chains multiple catchError callbacks', () {
      String errorMessage1 = "";
      String errorMessage2 = "";
      String errorMessage3 = "";

      final comingSoon = ComingSoon<int>(() {
        throw Exception('Initial Error');
      });

      comingSoon.catchError((error) {
        errorMessage1 = error.toString();
        throw Exception('Error from First catchError');
      }).catchError((error) {
        errorMessage2 = error.toString();
        throw Exception('Error from Second catchError');
      }).catchError((error) {
        errorMessage3 = error.toString();
        throw Exception('Error from Third catchError');
      });

      expect(errorMessage1, 'Exception: Initial Error');
      expect(errorMessage2, 'Exception: Error from First catchError');
      expect(errorMessage3, 'Exception: Error from Second catchError');
    });
  });
}
