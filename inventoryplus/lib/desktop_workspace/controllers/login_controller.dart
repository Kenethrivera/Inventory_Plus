// lib/desktop_workspace/controllers/login_controller.dart
import 'package:flutter/material.dart';
// Matching your exact capitalization
import '../data/AuthService.dart';

class LoginController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String errorMessage = '';
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // Parameter name reverted to username
  Future<String?> performLogin(String username, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // Call modified service using username
      final userRole = await _authService.authenticate(username, password);

      isLoading = false;
      notifyListeners();

      if (userRole == 'admin') return '/admin';
      if (userRole == 'staff') return '/staff';

      errorMessage = 'Error: Incorrect Username / Password';
      return null;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
