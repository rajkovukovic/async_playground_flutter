class ComingSoon<T> {
  bool _completed = false;
  final List<Function(T value)> _thenQueue = []; // [ mzaT, ianT ]
  final List<Function(Object value)> _errorQueue = []; // [  mzaE ]
  T? _value;
  Object? _error;
  ComingSoon? _newComingSoon;

  ComingSoon(
      Function(Function(T value) resolve, Function(Object obj) reject) cb) {
    cb(_handleSuccess, _handleError);
  }

  _handleSuccess(T value) {
    //500
    _value = value;
    _completed = true;

    for (var el in _thenQueue) {
      el.call(value);
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

  // ComingSoon<N> then<N>(Function(T value) thenCallback) {
  //   if (_completed) {
  //     thenCallback.call(_value as T);
  //     return ComingSoon(
  //       (resolve, reject) {},
  //     );
  //   } else {
  //     _thenQueue.add(thenCallback);
  //     return ComingSoon(
  //       (resolve, reject) {},
  //     );
  //   }
  // }

  ComingSoon<N> then<N>(N Function(T value) thenCallback) {
    return ComingSoon<N>((resolve, reject) {
      if (_completed) {
        if (_value != null) {
          final result = thenCallback(_value as T);
          resolve(result);
        }
      } else {
        _thenQueue.add((value) {
          final result = thenCallback(value);
          resolve(result);
        });
      }
      if (_error != null) {
        reject(_error!);
      }
    });
  }

  catchError(Function(Object? error) errorCallback) {
    if (_completed) {
      errorCallback.call(_error as Object);
    } else {
      _errorQueue.add(errorCallback);
    }
  }
}
