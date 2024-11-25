import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

class ComingSoon<T> {
  bool _completed = false;
  T? _value;
  Object? _error;
  ComingSoon(Cb<T> cb) {
    cb(_handleSuccess, _handleError);
  }

  _handleSuccess(T value) {
    _value = value;
    _completed = true;
  }

  _handleError(Object error) {
    _error = error;
    _completed = true;
  }

  then(Function(T? value) callback) {
    callback.call(_value);
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
