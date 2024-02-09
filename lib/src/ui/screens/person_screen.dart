import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:provider/provider.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthNotifier>();
    if (authState.user == null) {
      return const SignInScreen();
    } else {
      return const ProfileScreen(
        actions: [
          //   SignedOutAction((_) => context.go(Routes.start)),
        ],
      );
    }
  }
}
