import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  
  // Demo login - in production, this would integrate with Firebase
  Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Demo validation - accept any email/password for demo
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = {
        'id': 'demo_user_1',
        'email': email,
        'firstName': 'Adaora',
        'lastName': 'Okafor',
        'profileComplete': false,
      };
      
      // Store session token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', 'demo_token_123');
      await prefs.setString('user_data', email);
      
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  // Demo Google sign-in - design only
  Future<bool> signInWithGoogle() async {
    // Simulate Google sign-in flow
    await Future.delayed(const Duration(milliseconds: 1500));
    
    _isAuthenticated = true;
    _currentUser = {
      'id': 'demo_google_user',
      'email': 'adaora.okafor@gmail.com',
      'firstName': 'Adaora',
      'lastName': 'Okafor',
      'profileComplete': false,
      'provider': 'google',
    };
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', 'demo_google_token_456');
    await prefs.setString('user_data', 'adaora.okafor@gmail.com');
    
    notifyListeners();
    return true;
  }
  
  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_data');
    
    notifyListeners();
  }
  
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