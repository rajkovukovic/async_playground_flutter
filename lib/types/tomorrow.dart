import 'dart:async';

class Tomorrow<T> {
  bool _completed = false;
  T? _value;
  Function(T waitValue)? waitFunction;
  Function(Object error)? waitForError;
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
            secondTomorrow.then(
              (value) {
                resolve2.call(value);
              },
            );
          } else {
            resolve2.call(secondTomorrow);
          }
        };
      },
    );
  }

  Tomorrow<N> catchError<N>(Function(Object? error) errorCallback) {
    return Tomorrow<N>(
      (resolve, reject) {
        if (_completed) {
          try {
            errorCallback(error);
          } catch (newError) {
            reject(newError);
          }
        } else {
          waitForError = (error) {
            try {
              reject(error);
            } catch (newError) {
              reject(newError);
            }
          };
        }
      },
    );
  }
}
