import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../app/navigation/bottom_tab_navigator.dart';
import '../components/auth_primary_button.dart';
import '../components/auth_text_field.dart';
import '../components/social_login_buttons.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onSignUpSuccess;
  final VoidCallback? onLoginTap;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onFacebookLogin;
  final VoidCallback? onAppleLogin;

  const RegisterScreen({
    super.key,
    this.onSignUpSuccess,
    this.onLoginTap,
    this.onGoogleLogin,
    this.onFacebookLogin,
    this.onAppleLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Creating account for ${_fullNameController.text.trim()}...',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      // Save the new user (kept on the phone only if "Remember me" is ticked).
      SessionStorage.save(
        SavedUser(
          name: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
        ),
        remember: _rememberMe,
      );
      if (widget.onSignUpSuccess != null) {
        widget.onSignUpSuccess!();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: InkWell(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else if (widget.onLoginTap != null) {
                  widget.onLoginTap!();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.04,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Centered Mascot Logo with subtle ambient glow
                    Center(
                      child: Container(
                        width: 105,
                        height: 105,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: isDark ? 0.2 : 0.08,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/logo/Blue-and-White Panda LoveB.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Centered title
                    Text(
                      'Create an Account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 1: Full Name
                    AuthTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Field 2: Email
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
                    const SizedBox(height: 12),

                    // Field 3: Password
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Create a password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
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

                    // Field 4: Confirm Password
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleRegister(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Options: Remember me
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
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
                                        : const Color(0xFFCBD5E1),
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
                    ),
                    const SizedBox(height: 22),

                    // Action Button: Sign up
                    AuthPrimaryButton(
                      text: 'Sign up',
                      isLoading: _isLoading,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 26),

                    // Divider & Social Login
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
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'Or Log in with',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                              fontSize: 12,
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
                    const SizedBox(height: 20),

                    // Social login buttons
                    SocialLoginButtons(
                      onGoogleTap: widget.onGoogleLogin,
                      onFacebookTap: widget.onFacebookLogin,
                      onAppleTap: widget.onAppleLogin,
                    ),
                    const SizedBox(height: 30),

                    // Bottom Footer: Already have an account? Login
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.onLoginTap != null) {
                              widget.onLoginTap!();
                            } else if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
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

/// Alias for SignUpScreen to maintain full compatibility.
typedef SignUpScreen = RegisterScreen;
