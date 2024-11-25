class ComingSoon<T> {
  bool _completed = false;
  Function(T value)? _resolvedValue;
  T? _value;
  Object? _error;

  ComingSoon(Cb<T> cb) {
    cb(_handleSuccess, _handleError);
  }

  _handleSuccess(T value) {
    //500
    _value = value;
    _completed = true;
    _resolvedValue?.call(value);
  }

  _handleError(Object error) {
    _error = error;
    _completed = true;
  }

  then(Function(T value) thenCallback) {
    // 300
    _resolvedValue = thenCallback;
    if (_completed) {
      thenCallback.call(_value as T);
    }
  }

  catchError(Function(Object? error) callback) {
    callback.call(_error);
  }
}

typedef Cb<T> = Function(
    Function(T value) resolve, Function(Object obj) reject);

// const promise1 = new Promise((resolve, reject) => {
//   setTimeout(() => {
//     resolve('foo');
//   }, 300);
// });
