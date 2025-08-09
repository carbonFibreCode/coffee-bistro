import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koffee_bistro/routes/App_routes.dart';
import 'package:koffee_bistro/screens/cart_screen.dart';
import 'package:koffee_bistro/screens/login.dart';
import 'package:koffee_bistro/screens/main_screen.dart';
import 'package:koffee_bistro/screens/onboarding.dart';
import 'package:koffee_bistro/screens/product_detail_screen.dart';
import 'package:koffee_bistro/state/app_state.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.initialize();

  //seting up of the device orientation for the best user Experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  //basis of login status we redirect the different routes
  final String initialRoute = AppState.instance.authState.isLoggedIn.value
      ? AppRoutes.main
      : AppRoutes.onboarding;
  runApp(MyApp(initialRoute: initialRoute,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koffee Bistro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.soraTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: initialRoute, //now the route will be dynamic
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.productDetail: (context) => const ProductDetailScreen(),
        AppRoutes.main: (context) => const MainScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
      },
    );
  }
}

