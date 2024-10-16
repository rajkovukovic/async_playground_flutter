import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/user.dart';
import 'package:flutter/material.dart';

/// AuthView displays each user from [mockUsers] as a button with
/// "Sign in {username}" text
/// if AuthView property [authUserId] is not null
/// button for that user becomes dark green and displays "Sign out {username}"
class AuthView extends StatelessWidget {
  final List<User> users;
  final String? authUserId;
  final Function(User)? onUserSignedIn;
  final Function()? onUserSignedOut;

  const AuthView({
    super.key,
    required this.users,
    this.authUserId,
    this.onUserSignedIn,
    this.onUserSignedOut,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: mockUsers.map(
        (user) {
          final isAuthUser = authUserId == user.id;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (isAuthUser) {
                  onUserSignedOut?.call();
                } else {
                  onUserSignedIn?.call(user);
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(isAuthUser ? Colors.green : null),
              ),
              child: Text(isAuthUser
                  ? 'Sign out ${user.name}'
                  : 'Sign in ${user.name}'),
            ),
          );
        },
      ).toList(),
    );
  }
}
