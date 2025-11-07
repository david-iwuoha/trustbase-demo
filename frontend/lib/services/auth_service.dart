import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'api_config.dart'; // <-- your backend URL

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;

  /// -------------------------------
  /// Login with email/password
  /// -------------------------------
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _isAuthenticated = true;
        _currentUser = data['user']; // backend returns user info

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', data['token']);
        await prefs.setString('user_data', email);

        notifyListeners();
        return true;
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error connecting to backend: $e');
      return false;
    }
  }

  /// -------------------------------
  /// Google Sign-In
  /// -------------------------------
  Future<bool> signInWithGoogle() async {
    try {
      // Step 1: Open Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false; // user cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 2: Send ID token to backend
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google-signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': googleAuth.idToken}),
      );

      // Step 3: Handle backend response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _isAuthenticated = true;
        _currentUser = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', data['token']);
        await prefs.setString('user_data', data['user']['email']);

        notifyListeners();
        return true;
      } else {
        print('Google auth failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      return false;
    }
  }

  /// -------------------------------
  /// Logout
  /// -------------------------------
  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_data');

    notifyListeners();
  }

  /// -------------------------------
  /// Check auth status (on app start)
  /// -------------------------------
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    final userData = prefs.getString('user_data');

    if (token != null && userData != null) {
      _isAuthenticated = true;
      _currentUser = {
        'id': 'demo_user_1',
        'email': userData,
        'firstName': 'Adaora',
        'lastName': 'Okafor',
        'profileComplete': false,
      };
      notifyListeners();
    }
  }
}
