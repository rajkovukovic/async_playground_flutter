import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/coming_soon.dart';
import 'package:async_playground_flutter/models/user.dart';
import 'package:async_playground_flutter/utils/delays.dart';

class AuthService {
  static ComingSoon<User> loginCallback(String userId) {
    return ComingSoon<User>((resolve, reject) {
      // Use the delay defined in the delays utility
      Future.delayed(loginDuration(), () {
        final user = mockUsers.where((user) => user.id == userId).firstOrNull;
        if (user != null) {
          resolve(user); // Resolve with the user if found
        } else {
          reject('User not found'); // Reject with an error message if not found
        }
      });
    });
  }
}
