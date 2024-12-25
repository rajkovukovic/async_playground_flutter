import 'dart:async';

class Tomorrow<T> {
  bool? _completed;
  T? _value;
  Function(T waitValue)? waitFunction;
  Object? error;

  Tomorrow(
      Function(Function(dynamic value) resolve, Function(Object error) reject)
          cb) {
    cb(_resolve, _reject);
  }

  factory Tomorrow.delayed(Duration duration, T value) {
    return Tomorrow(
      (resolve, reject) {
        Timer(duration, () => resolve(value));
      },
    );
  }

  _resolve(value) {
    _value = value;
    waitFunction?.call(_value as T);
    _completed = true;
  }

  _reject(Object error) {
    error = error;
    _completed = true;
  }

  Tomorrow<R> then<R>(dynamic Function(T value) callerFn) {
    return Tomorrow<R>(
      (resolve2, reject2) {
        waitFunction = (waitedValue) {
          dynamic secondTomorrow = callerFn(waitedValue);

          if (secondTomorrow is Tomorrow) {
            // secondTomorrow
          } else {
            resolve2.call(secondTomorrow);
          }
        };
      },
    );
  }

  catchError(Object error) {}
}
