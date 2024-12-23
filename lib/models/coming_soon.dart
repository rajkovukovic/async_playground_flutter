import 'dart:async';

class ComingSoon<T> {
  final List<Function(T)> _successCallbacks = [];
  final List<Function(Object)> _errorCallbacks = [];
  bool _completed = false;
  T? _result;
  Object? _error;

  ComingSoon(void Function(Function(T), Function(Object)) operation) {
    _executeOperation(operation);
  }

  void _executeOperation(
      void Function(Function(T), Function(Object)) operation) {
    try {
      operation(_resolve, _reject);
    } catch (error) {
      _reject(error);
    }
  }

  void _resolve(T result) {
    if (_completed) throw StateError("Future is already completed.");
    _completed = true;
    _result = result;

    for (var callback in _successCallbacks) {
      callback(result);
    }
  }

  void _reject(Object error) {
    if (_completed) throw StateError("Future is already completed.");
    _completed = true;
    _error = error;
    for (var callback in _errorCallbacks) {
      callback(error);
    }
  }

  ComingSoon<R> then<R>(dynamic Function(T) callback) {
    var nextComingSoon = ComingSoon<R>((resolve, reject) {
      _successCallbacks.add((result) {
        try {
          final value = callback(result);
          if (value is ComingSoon<R>) {
            value._successCallbacks.add(resolve);
            value._errorCallbacks.add(reject);
          } else {
            resolve(value);
          }
        } catch (error) {
          reject(error);
        }
      });

      if (_completed && _result != null) {
        try {
          final value = callback(_result!);
          if (value is ComingSoon<R>) {
            value._successCallbacks.add(resolve);
            value._errorCallbacks.add(reject);
          } else {
            resolve(value);
          }
        } catch (error) {
          reject(error);
        }
      }
    });

    return nextComingSoon;
  }

  ComingSoon<T> catchError(dynamic Function(Object) callback) {
    var nextComingSoon = ComingSoon<T>((resolve, reject) {
      _errorCallbacks.add((error) {
        try {
          final value = callback(error);
          if (value is ComingSoon<T>) {
            value._successCallbacks.add(resolve);
            value._errorCallbacks.add(reject);
          } else {
            resolve(value);
          }
        } catch (newError) {
          reject(newError);
        }
      });

      if (_completed && _error != null) {
        try {
          final value = callback(_error!);
          if (value is ComingSoon<T>) {
            value._successCallbacks.add(resolve);
            value._errorCallbacks.add(reject);
          } else {
            resolve(value);
          }
        } catch (newError) {
          reject(newError);
        }
      }
    });

    return nextComingSoon;
  }

  Future<T> asFuture() {
    final completer = Completer<T>();
    this.then((v) => completer.complete(v));
    this.catchError((error) => completer.completeError(error));
    return completer.future;
  }

  static ComingSoon<T> delayed<T>(
    Duration duration, [
    T Function()? computation,
  ]) {
    return ComingSoon((resolve, reject) {
      Future.delayed(duration, computation).then(resolve).catchError(reject);
    });
  }
}
