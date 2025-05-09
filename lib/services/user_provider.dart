import 'package:flutter/material.dart';
import 'package:alcipen/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  UserRole? _selectedRole;

  User? get currentUser => _currentUser;
  UserRole? get selectedRole => _selectedRole;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setSelectedRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  bool get isSeeker => _currentUser?.role == UserRole.seeker;
  bool get isWriter => _currentUser?.role == UserRole.writer;
  bool get isLoggedIn => _currentUser != null;
}