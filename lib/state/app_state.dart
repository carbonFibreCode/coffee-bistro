import 'package:koffee_bistro/state/auth_state.dart';
import 'package:koffee_bistro/state/cart_state.dart';
import 'package:koffee_bistro/state/home_state.dart';
import 'package:koffee_bistro/state/navigation_state.dart';
import 'package:koffee_bistro/state/product_detail_state.dart';

/// A central service to hold and provide all application state managers.
/// This class follows a singleton pattern to ensure a single instance
/// throughout the app's lifecycle.
class AppState {
  // Private constructor
  AppState._privateConstructor();

  // the single, static instance of the class
  static final AppState _instance = AppState._privateConstructor();

  // public accessor for the instance
  static AppState get instance => _instance;

  // Instances of all the state managers
  final AuthState authState = AuthState();
  final HomeState homeState = HomeState();
  final ProductDetailState productDetailState = ProductDetailState();
  final CartState cartState = CartState();
  final NavigationState navigationState = NavigationState();


  Future<void> initialize() async {
    await authState.checkLoginStatus();
    await homeState.initialize();
    await cartState.initialize();
  }
}