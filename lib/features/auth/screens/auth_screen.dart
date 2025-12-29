import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsLogin;

  const AuthScreen({super.key, this.initialIsLogin = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin;
  bool _showEmailForm = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.initialIsLogin;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await _authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
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
      await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
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
      await _authService.signInWithApple();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            if (_showEmailForm) {
              setState(() => _showEmailForm = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showEmailForm ? _buildEmailForm() : _buildWelcomeVariant(),
        ),
      ),
    );
  }

  Widget _buildWelcomeVariant() {
    return SingleChildScrollView(
      key: const ValueKey('welcome'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Image / Illustration
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.userCircle,
                size: 160,
                color: Colors.grey.shade200,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),

          const SizedBox(height: 32),

          Text(
            "Let's you in",
            style: GoogleFonts.inter(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 32),

          // Social Buttons - Refined with shadows and outlines
          _buildSocialButton(
            icon: FontAwesomeIcons.google,
            label: "Continue with Google",
            color: Colors.red,
            isLoading: _isGoogleLoading,
            onTap: _handleGoogleSignIn,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),

          _buildSocialButton(
            icon: FontAwesomeIcons.apple,
            label: "Continue with Apple",
            color: Colors.black,
            isLoading: _isAppleLoading,
            onTap: _handleAppleSignIn,
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 48),

          Row(
            children: [
              Expanded(
                child: Divider(color: Colors.grey.shade200, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "or",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.grey.shade200, thickness: 1),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 32),

          // Primary Button for Password
          _buildPrimaryButton(
            onPressed: () => setState(() {
              _isLogin = true;
              _showEmailForm = true;
            }),
            text: "Sign in with password",
          ).animate().fadeIn(delay: 700.ms),

          const SizedBox(height: 40),

          _buildAuthToggleLink(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmailForm() {
    return SingleChildScrollView(
      key: const ValueKey('email_form'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            _isLogin ? "Login to your\nAccount" : "Create your\nAccount",
            style: GoogleFonts.inter(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ).animate().fadeIn().slideX(begin: -0.1),

          const SizedBox(height: 40),

          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _emailController,
                  hint: "Email",
                  icon: LucideIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hint: "Password",
                  icon: LucideIcons.lock,
                  isPassword: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                "Remember me",
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 32),

          _buildPrimaryButton(
            onPressed: _handleEmailAuth,
            text: _isLogin ? "Sign in" : "Sign up",
            isLoading: _isLoading,
          ),

          if (_isLogin) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/auth/forgot-password'),
                child: Text(
                  "Forgot the password?",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade200)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "or continue with",
                  style: GoogleFonts.inter(color: Colors.grey.shade500),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade200)),
            ],
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSmallSocialButton(
                FontAwesomeIcons.google,
                Colors.red,
                onTap: _handleGoogleSignIn,
                isLoading: _isGoogleLoading,
              ),
              _buildSmallSocialButton(
                FontAwesomeIcons.apple,
                Colors.black,
                onTap: _handleAppleSignIn,
                isLoading: _isAppleLoading,
              ),
            ],
          ),

          const SizedBox(height: 48),

          _buildAuthToggleLink(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(icon, color: color, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSmallSocialButton(
    IconData icon,
    Color color, {
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 100,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Center(child: FaIcon(icon, color: color, size: 24)),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                color: Colors.grey.shade400,
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildAuthToggleLink() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_showEmailForm) {
              _isLogin = !_isLogin;
            } else {
              _isLogin = false;
              _showEmailForm = true;
            }
          });
        },
        child: RichText(
          text: TextSpan(
            text: _isLogin
                ? "Don't have an account? "
                : "Already have an account? ",
            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 16),
            children: [
              TextSpan(
                text: _isLogin ? "Sign up" : "Sign in",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
