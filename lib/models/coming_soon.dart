class ComingSoon<T> {
  Function(T)? _successCallback;
  Function(Object)? _errorCallback;
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
    if (_successCallback != null) {
      _successCallback!(result);
    }
  }

  void _reject(Object error) {
    if (_completed) throw StateError("Future is already completed.");
    _completed = true;
    _error = error;
    if (_errorCallback != null) {
      _errorCallback!(error);
    }
  }

  ComingSoon<T> then(void Function(T) callback) {
    _successCallback = callback;
    if (_completed && _result != null) {
      callback(_result!);
    }
    return this;
  }

  ComingSoon<T> catchError(void Function(Object) callback) {
    _errorCallback = callback;
    if (_completed && _error != null) {
      callback(_error!);
    }
    return this;
  }
}
