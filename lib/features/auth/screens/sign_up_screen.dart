import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/oauth_button.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/common/auth_divider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _acceptTerms = false;

  Future<void> _handleSignUp() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the terms and conditions"),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Account created successfully! Please check your email.",
            ),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigate back to sign in
        context.pushReplacement('/auth/signin');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign up failed: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    try {
      // TODO: Implement Google sign-in
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Google sign-in failed: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isAppleLoading = true);
    try {
      // TODO: Implement Apple sign-in
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Apple sign-in failed: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 8),

                  Text(
                    "Join the fashion revolution",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),

              const SizedBox(height: 32),

              // Social authentication
              Column(
                children: [
                  GoogleOAuthButton(
                    onPressed: _handleGoogleSignIn,
                    isLoading: _isGoogleLoading,
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 12),

                  if (Theme.of(context).platform == TargetPlatform.iOS)
                    AppleOAuthButton(
                      onPressed: _handleAppleSignIn,
                      isLoading: _isAppleLoading,
                    ).animate().fadeIn(delay: 350.ms),

                  const SizedBox(height: 32),

                  const AuthDivider().animate().fadeIn(delay: 400.ms),
                ],
              ),

              const SizedBox(height: 32),

              // Form container
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Name fields row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: "First Name",
                              hintText: "John",
                              prefixIcon: Icon(LucideIcons.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: "Last Name",
                              hintText: "Doe",
                              prefixIcon: Icon(LucideIcons.user),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 20),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "john.doe@example.com",
                        prefixIcon: Icon(LucideIcons.mail),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ).animate().fadeIn(delay: 550.ms),

                    const SizedBox(height: 20),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Create a strong password",
                        prefixIcon: Icon(LucideIcons.lock),
                      ),
                      obscureText: true,
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 20),

                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Re-enter your password",
                        prefixIcon: Icon(LucideIcons.lock),
                      ),
                      obscureText: true,
                    ).animate().fadeIn(delay: 650.ms),

                    const SizedBox(height: 24),

                    // Terms and conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() => _acceptTerms = value ?? false);
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                          checkColor: Theme.of(context).colorScheme.onPrimary,
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "I agree to the Terms of Service and Privacy Policy",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 32),

                    // Create account button
                    PrimaryButton(
                      text: "Create Account",
                      onPressed: _handleSignUp,
                      isLoading: _isLoading,
                    ).animate().fadeIn(delay: 750.ms),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sign in navigation
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pushReplacement('/auth/signin');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
