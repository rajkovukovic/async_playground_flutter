class ComingSoon<T> {
  final List<Function(T)> _successCallbacks = [];
  final List<Function(Object)> _errorCallbacks = [];
  bool _completed = false;
  T? _result;
  Object? _error;

  ComingSoon(Function() operation) {
    _executeOperation(operation);
  }

  void _executeOperation(Function() operation) {
    try {
      T result = operation() as T;
      _resolve(result);
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

  ComingSoon<R> then<R>(R Function(T) callback) {
    return ComingSoon<R>.promiseLike((resolve, reject) {
      _successCallbacks.add((result) {
        try {
          final nextResult = callback(result);
          resolve(nextResult);
        } catch (error) {
          reject(error);
        }
      });

      if (_completed && _result != null) {
        try {
          final nextResult = callback(_result!);
          resolve(nextResult);
        } catch (error) {
          reject(error);
        }
      }
    });
  }

  ComingSoon<T> catchError(T Function(Object) callback) {
    return ComingSoon<T>.promiseLike((resolve, reject) {
      _errorCallbacks.add((error) {
        try {
          final nextResult = callback(error);
          resolve(nextResult);
        } catch (newError) {
          reject(newError);
        }
      });

      if (_completed && _error != null) {
        try {
          final nextResult = callback(_error!);
          resolve(nextResult);
        } catch (newError) {
          reject(newError);
        }
      }
    });
  }

  ComingSoon.promiseLike(
      void Function(Function(T) resolve, Function(Object) reject) executor) {
    try {
      executor(_resolve, _reject);
    } catch (error) {
      _reject(error);
    }
  }
}
