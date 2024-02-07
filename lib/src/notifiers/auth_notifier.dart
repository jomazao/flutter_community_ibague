import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthNotifier({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    init();
  }

  User? user;

  late final StreamSubscription<User?> _userSubscription;

  void init() {
    _userSubscription = _firebaseAuth.authStateChanges().listen((user) {
      this.user = user;
      notifyListeners();
    });
  }
}
