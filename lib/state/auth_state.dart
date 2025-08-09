import 'package:koffee_bistro/api/mock_coffee_service.dart';
import 'package:koffee_bistro/models/user.dart';
import 'package:koffee_bistro/state/value_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// manages the authentication state and logic of the application.
class AuthState {
  // key for storing login status in SharedPreferences
  static const String _isLoggedInKey = 'isLoggedIn';

  final MockCoffeeService _coffeeService = MockCoffeeService();

  // --- Reactive State Properties ---

  /// notifier for the current authenticated user. Null if logged out.
  final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

  /// notifier for auth-related loading states (e.g., during login).
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// notifier that is true if the user is authenticated.
  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  /// Notifier for toggling password visibility on the login screen.
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);



  /// logging in the user
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    final user = await _coffeeService.login(email, password);
    isLoading.value = false;

    if (user != null) {
      // successful login:
      currentUser.value = user;
      isLoggedIn.value = true;
      await _saveLoginState(true); // persist state
      return true;
    } else {
      //failed login:
      return false;
    }
  }

  /// Logs out.
  Future<void> logout() async {
    currentUser.value = null;
    isLoggedIn.value = false;
    await _saveLoginState(false); // persist state
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final wasLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    isLoggedIn.value = wasLoggedIn;
  }

  /// saving  the user's logged-in flag to SharedPreferences.
  Future<void> _saveLoginState(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, loggedIn);
  }
}