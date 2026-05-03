// lib/desktop_workspace/view/pages/login_page.dart
import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _loginController = LoginController();

  static const _bgColor = Color(0xFF0F172A);
  static const _orangeAccent = Color(0xFFEA580C);
  static const _inputFieldColor = Color(0xFF1E293B);
  static const _textGrey = Color(0xFF94A3B8);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  void _handleLoginPress() async {
    final routeDestination = await _loginController.performLogin(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (routeDestination != null && mounted) {
      Navigator.pushReplacementNamed(context, routeDestination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: ListenableBuilder(
        listenable: _loginController,
        builder: (context, child) {
          // 1. ADDED STACK: This allows us to put decorative elements behind the login box
          return Stack(
            children: [
              // --- Background Decorative Elements ---
              Positioned(
                top: -50,
                left: -50,
                child: Icon(
                  Icons.inventory_2,
                  size: 400,
                  color: Colors.white.withOpacity(0.02),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -50,
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: 500,
                  color: Colors.white.withOpacity(0.02),
                ),
              ),
              Positioned(
                top: 150,
                right: 150,
                child: Icon(
                  Icons.widgets_outlined,
                  size: 200,
                  color: Colors.white.withOpacity(0.02),
                ),
              ),
              Positioned(
                bottom: 150,
                left: 150,
                child: Icon(
                  Icons.precision_manufacturing_outlined,
                  size: 250,
                  color: Colors.white.withOpacity(0.02),
                ),
              ),

              // --- Main Login Container ---
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 450,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Color(0xFF1E293B),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              size: 60,
                              color: _orangeAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Inventory Plus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hardware Management System',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: _textGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 60),

                        _buildLabel('USERNAME'),
                        const SizedBox(height: 12),
                        _buildDarkTextField(
                          controller: _usernameController,
                          hintText: 'Enter your username',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 32),

                        _buildLabel('PASSWORD'),
                        const SizedBox(height: 12),
                        _buildDarkTextField(
                          controller: _passwordController,
                          hintText: '********',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 40),

                        if (_loginController.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              _loginController.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        // 2. UPDATED BUTTON: Keeps its shape and text, just fades out and adds a spinner next to the text
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _loginController.isLoading
                                ? null
                                : _handleLoginPress,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _orangeAccent,
                              foregroundColor: Colors.white,
                              // Prevents the button from turning completely grey when disabled
                              disabledBackgroundColor: _orangeAccent
                                  .withOpacity(0.5),
                              disabledForegroundColor: Colors.white.withOpacity(
                                0.8,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_loginController.isLoading)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_loginController.isLoading,
      obscureText: isPassword && !_loginController.isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF475569)),
        prefixIcon: Icon(prefixIcon, color: _orangeAccent, size: 22),
        suffixIcon: isPassword
            // 3. UPDATED ICON SPACING: Added padding to push the eye icon to the left
            ? Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  hoverColor: Colors.white.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.2),
                  splashRadius: 24,
                  icon: Icon(
                    _loginController.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: _loginController.isPasswordVisible
                        ? Colors.white
                        : const Color(0xFF475569),
                  ),
                  onPressed: _loginController.togglePasswordVisibility,
                ),
              )
            : null,
        filled: true,
        fillColor: _inputFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
      ),
    );
  }
}
