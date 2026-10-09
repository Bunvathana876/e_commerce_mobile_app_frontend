import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../app/navigation/bottom_tab_navigator.dart';
import '../components/auth_primary_button.dart';
import '../components/auth_text_field.dart';
import '../components/social_login_buttons.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onFacebookLogin;
  final VoidCallback? onAppleLogin;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onCreateAccount,
    this.onGoogleLogin,
    this.onFacebookLogin,
    this.onAppleLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logging in as ${_emailController.text.trim()}...'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      // Save who logged in (kept on the phone only if "Remember me" is ticked).
      final email = _emailController.text.trim();
      final known = SessionStorage.currentUser;
      SessionStorage.save(
        SavedUser(
          name: (known != null && known.email == email)
              ? known.name
              : email.split('@').first,
          email: email,
        ),
        remember: _rememberMe,
      );
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomTabNavigator()),
        );
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // Centered Logo with soft ambient glow
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface.withValues(alpha: 0.5)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: isDark ? 0.12 : 0.08,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo/Blue-and-White Panda Waving.png',
                          height: 140,
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header Text
                    Text(
                      'Welcome to ShopPanda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Login now!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Email Field
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Password Field
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Options Row: Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _rememberMe = !_rememberMe;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 2.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.primary,
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: BorderSide(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : const Color(0xFF94A3B8),
                                      width: 1.5,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onForgotPassword ?? () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 2.0,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF60A5FA)
                                  : AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Main Action Button (Login)
                    AuthPrimaryButton(
                      text: 'Login',
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 28),

                    // Divider Row
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or Log in with',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Logins
                    SocialLoginButtons(
                      onGoogleTap: widget.onGoogleLogin,
                      onFacebookTap: widget.onFacebookLogin,
                      onAppleTap: widget.onAppleLogin,
                    ),
                    const SizedBox(height: 36),

                    // Bottom Navigation
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Didn't have an account? ",
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              widget.onCreateAccount ??
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                          child: Text(
                            'Create an account',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF60A5FA)
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
