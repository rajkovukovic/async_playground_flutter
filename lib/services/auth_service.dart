import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/user.dart';
import 'package:async_playground_flutter/types/callback.dart';
import 'package:async_playground_flutter/types/coming_soon.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class AuthService {
  static ComingSoon<User> loginComingSoon(String userId) {
    return ComingSoon(
      (resolve, reject) {
        Future.delayed(loginDuration(), () {
          final user = mockUsers.where((user) => user.id == userId).firstOrNull;
          if (user != null) {
            resolve(user);
          } else {
            reject('User not found');
          }
        });
      },
    );
  }

  static void loginCallback(String userId, Callback<User> callback) {
    Future.delayed(loginDuration(), () {
      final user = mockUsers.where((user) => user.id == userId).firstOrNull;
      if (user != null) {
        callback(null, user);
      } else {
        callback('User not found', null);
      }
    });
  }
}
