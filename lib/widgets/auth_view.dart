import 'package:async_playground_flutter/mocks/mock_users.dart';
import 'package:async_playground_flutter/models/user.dart';
import 'package:flutter/material.dart';

/// Displays a list of users from [mockUsers] as sign-in buttons.
/// If [authUserId] matches a user's ID, their button turns dark green
/// and shows "Sign out {username}". Otherwise, it shows "Sign in {username}".
/// Handles user sign-in and sign-out via [onUserSignedIn] and [onUserSignedOut] callbacks.
class AuthView extends StatelessWidget {
  final List<User> users;
  final String? authUserId;
  final Function(User)? onUserSignedIn;
  final Function(User)? onUserSignedOut;

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
                  onUserSignedOut?.call(user);
                } else {
                  onUserSignedIn?.call(user);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  isAuthUser ? Colors.deepPurple.shade100 : null,
                ),
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
