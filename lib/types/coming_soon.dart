import 'dart:async';

class ComingSoon<T> {
  bool _completed = false;
  final List<Function(T value)> _thenQueue = []; // [ mzaT, ianT ]
  final List<Function(Object value)> _errorQueue = []; // [  mzaE ]
  T? _value;
  Object? _error;

  ComingSoon(
      Function(Function(T value) resolve, Function(Object obj) reject) cb) {
    cb(_handleSuccess, _handleError);
  }

  factory ComingSoon.value(T value) {
    return ComingSoon<T>((resolve, reject) => resolve(value));
  }

  factory ComingSoon.error(Object error) {
    return ComingSoon<T>((resolve, reject) => reject(error));
  }

  factory ComingSoon.delayedValue(Duration duration, T value) {
    return ComingSoon<T>((resolve, reject) {
      Timer(duration, () => resolve(value));
    });
  }

  factory ComingSoon.delayedError(Duration duration, Object error) {
    return ComingSoon<T>((resolve, reject) {
      Timer(duration, () => reject(error));
    });
  }

  _handleSuccess(T value) {
    _value = value;
    _completed = true;

    for (var fn in _thenQueue) {
      fn.call(value);
    }
    _thenQueue.clear();
    _errorQueue.clear();
  }

  _handleError(Object error) {
    _error = error;
    _completed = true;
    for (var el in _errorQueue) {
      el.call(error);
    }
    _thenQueue.clear();
    _errorQueue.clear();
  }

  ComingSoon<R> then<R>(ComingSoon<R> Function(T value) thenCallback) {
    return ComingSoon<R>(
      (resolveFinal, rejectFinal) {
        happy(zika) {
          try {
            ComingSoon<R> inner = thenCallback(zika);
            inner.then((value) => resolveFinal(value));
            inner.catchError((error) => rejectFinal(error!));
            return inner;
          } catch (error) {
            rejectFinal(error);
          }
        }

        _errorQueue.add(rejectFinal);
        _thenQueue.add(happy);
      },
    );
  }

  ComingSoon<N> catchError<N>(Function(Object? error) errorCallback) {
    return ComingSoon<N>(
      (resolve, reject) {
        if (_completed) {
          try {
            errorCallback(_error);
          } catch (newError) {
            reject(newError);
          }
        } else {
          _errorQueue.add((error) {
            try {
              reject(error);
            } catch (newError) {
              reject(newError);
            }
          });
        }
      },
    );
  }
}
