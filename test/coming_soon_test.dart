import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:async_playground_flutter/models/coming_soon.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ComingSoon tests', () {
    test('Chains multiple then calls with same type', () {
      String result = "";
      Completer<void> completer = Completer<void>();

      ComingSoon<String>((resolve, reject) {
        resolve("Result");
      }).then((value) {
        "$value -> Then 1";
      }).then((value) {
        "$value -> Then 2";
      }).then((value) {
        result = value;
        completer.complete();
      });

      completer.future.then((_) {
        expect(result, equals("Result -> Then 1 -> Then 2"));
      });
    });

    test('Chains multiple then calls with different types', () {
      String result = "";
      Completer<void> completer = Completer<void>();

      ComingSoon<int>((resolve, reject) {
        resolve(27);
      }).then((value) {
        value.toDouble();
      }).then((value) {
        "The value is $value";
      }).then((value) {
        result = value;
        completer.complete();
      });

      completer.future.then((_) {
        expect(result, equals("The value is 27.0"));
      });
    });

    test('Catches error and invokes catchError callback', () {
      String errorMessage = "";
      Completer<void> completer = Completer<void>();

      final comingSoon = ComingSoon<int>((resolve, reject) {
        reject(Exception('Test Error'));
      });

      comingSoon.catchError((error) {
        errorMessage = error.toString();
        completer.complete();
      });

      completer.future.then((_) {
        expect(errorMessage, 'Exception: Test Error');
      });
    });

    test('Catches error and chains multiple catchError callbacks', () {
      String errorMessage1 = "";
      String errorMessage2 = "";
      String errorMessage3 = "";
      Completer<void> completer = Completer<void>();

      final comingSoon = ComingSoon<int>((resolve, reject) {
        reject(Exception('Initial Error'));
      });

      comingSoon.catchError((error) {
        errorMessage1 = error.toString();
        throw Exception('Error from First catchError');
      }).catchError((error) {
        errorMessage2 = error.toString();
        throw Exception('Error from Second catchError');
      }).catchError((error) {
        errorMessage3 = error.toString();
        completer.complete();
      });

      completer.future.then((_) {
        expect(errorMessage1, 'Exception: Initial Error');
        expect(errorMessage2, 'Exception: Error from First catchError');
        expect(errorMessage3, 'Exception: Error from Second catchError');
      });
    });

    test('Chaining then with Future.delayed', () {
      String result = "";
      Completer<void> completer = Completer<void>();

      ComingSoon<int>((resolve, reject) {
        resolve(5);
      }).then((value) {
        Future.delayed(const Duration(seconds: 1), () {
          "$value -> After delay";
        });
      }).then((value) {
        result = value;
        completer.complete();
      });

      completer.future.then((_) {
        expect(result, equals("5 -> After delay"));
      });
    });

    test('Catching errors with Future.delayed', () {
      String errorMessage = "";
      Completer<void> completer = Completer<void>();

      ComingSoon<String>((resolve, reject) {
        reject(Exception('Initial Error'));
      }).catchError((error) {
        Future.delayed(const Duration(seconds: 1), () {
          "Handled error: $error";
        });
      }).then((value) {
        errorMessage = value;
        completer.complete();
      });

      completer.future.then((_) {
        expect(errorMessage, equals("Handled error: Exception: Initial Error"));
      });
    });

    test('Chains multiple then calls with Future.delayed', () {
      String result = "";
      Completer<void> completer = Completer<void>();

      ComingSoon<int>((resolve, reject) {
        resolve(10);
      }).then((value) {
        Future.delayed(const Duration(seconds: 5), () {
          "$value -> After 5 seconds";
        });
      }).then((value) {
        Future.delayed(const Duration(seconds: 1), () {
          "$value -> After 1 second";
        });
      }).then((value) {
        Future.delayed(const Duration(seconds: 4), () {
          result = "$value -> Final result";
          completer.complete();
        });
      });

      completer.future.then((_) {
        expect(result,
            equals("10 -> After 5 seconds -> After 1 second -> Final result"));
      });
    });
  });
}
