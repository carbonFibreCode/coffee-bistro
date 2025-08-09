import 'dart:ui'; // Import this for ImageFilter.
import 'package:flutter/material.dart';
import 'package:koffee_bistro/routes/App_routes.dart';
import 'package:koffee_bistro/state/app_state.dart';
import 'package:koffee_bistro/theme/app_theme.dart';
import 'package:koffee_bistro/widgets/app_snackbar.dart';
import 'package:koffee_bistro/widgets/value_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authState = AppState.instance.authState;

  void showLoginError() {
    AppSnackbar.show(
      context,
      'Invalid email or password',
      const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // glassmorphism Effect Layer to make the content clearer
          Positioned.fill(
            // BackdropFilter applies the blur to the area behind it.
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              // A semi-transparent overlay to complete the "glass" look.
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

          // The Login Form UI (on top of the blurred background)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    cursorColor: AppTheme.primary,
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: AppTheme.lightGrey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppTheme.lightGrey),
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppTheme.primary),
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ValueBuilder(
                    notifier: authState.isPasswordVisible,
                    builder: (context, isVisible) {
                      return TextField(
                        cursorColor: AppTheme.primary,
                        controller: _passwordController,
                        obscureText: !isVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: AppTheme.lightGrey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.lightGrey,
                            ),
                            onPressed: () {
                              authState.isPasswordVisible.value = !isVisible;
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppTheme.lightGrey,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppTheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ValueBuilder(
                    notifier: authState.isLoading,
                    builder: (context, loading) {
                      return ElevatedButton(
                        onPressed: loading
                            ? null
                            : () async {
                                final success = await authState.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                if (success) {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed(AppRoutes.main);
                                  AppSnackbar.show(
                                    context,
                                    'Logged in',
                                    const Duration(seconds: 1),
                                  );
                                } else {
                                  showLoginError();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius,
                            ),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}