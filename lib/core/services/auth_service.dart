import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth _firebaseAuth;
  var _userSubject = BehaviorSubject<User>();

  AuthService() {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.userChanges().listen((event) => _userSubject.add(event));
  }

  Stream<User> userStream() {
    return _userSubject.stream;
  }

  Future<bool> isAuthenticated() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<void> authenticate() {
    return _firebaseAuth.signInAnonymously();
  }

  String getUserId() {
    return (_firebaseAuth.currentUser).uid;
  }

  @override
  void dispose() {
    super.dispose();
    _userSubject.close();
  }
}
