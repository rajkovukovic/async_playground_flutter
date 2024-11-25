class ComingSoon<T> {
  bool _completed = false;
  final List<Function(T value)> _thenQueue = []; // [ mzaT, ianT ]
  final List<Function(Object value)> _errorQueue = []; // [  mzaE ]
  T? _value;
  Object? _error;

  ComingSoon(Cb<T> cb) {
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

  then(Function(T value) thenCallback) {
    if (_completed) {
      thenCallback.call(_value as T);
    } else {
      _thenQueue.add(thenCallback);
    }
  }

  catchError(Function(Object? error) errorCallback) {
    if (_completed) {
      errorCallback.call(_error as Object);
    } else {
      _errorQueue.add(errorCallback);
    }
  }
}

typedef Cb<T> = Function(
    Function(T value) resolve, Function(Object obj) reject);

// const promise1 = new Promise((resolve, reject) => {
//   setTimeout(() => {
//     resolve('foo');
//   }, 300);
// });

var hugeObject = [];

mboCallBack(error) {
  print(hugeObject);
}
