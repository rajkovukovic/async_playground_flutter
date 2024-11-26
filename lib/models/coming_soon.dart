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

  ComingSoon<T> then(void Function(T) callback) {
    _successCallbacks.add(callback);
    if (_completed && _result != null) {
      callback(_result!);
    }
    return this;
  }

  ComingSoon<T> catchError(void Function(Object) callback) {
    _errorCallbacks.add(callback);
    if (_completed && _error != null) {
      callback(_error!);
    }
    return this;
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
