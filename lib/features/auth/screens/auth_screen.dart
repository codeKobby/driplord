import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/components/common/auth_divider.dart';
import '../../../core/components/buttons/oauth_button.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import '../../closet/providers/closet_provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final bool initialIsLogin;

  const AuthScreen({super.key, this.initialIsLogin = true});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
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
        _navigateBasedOnCloset();
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
        _navigateBasedOnCloset();
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
        _navigateBasedOnCloset();
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

  void _navigateBasedOnCloset() {
    final closet = ref.read(closetProvider);
    if (closet.isEmpty) {
      context.go('/onboarding/scan');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      LucideIcons.arrowLeft,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      if (_showEmailForm) {
                        setState(() => _showEmailForm = false);
                      } else {
                        context.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showEmailForm
                    ? _buildEmailForm()
                    : _buildWelcomeVariant(),
              ),
            ),
          ],
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

          // Icon Group
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                LucideIcons.lock,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),

          const SizedBox(height: 48),

          Text(
            "Access Your Style",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 48),

          // Social Buttons
          _buildSocialButton(
            icon: FontAwesomeIcons.google,
            label: "Continue with Google",
            iconColor: Colors.red,
            isLoading: _isGoogleLoading,
            onTap: _handleGoogleSignIn,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),

          _buildSocialButton(
            icon: FontAwesomeIcons.apple,
            label: "Continue with Apple",
            iconColor: Theme.of(context).colorScheme.onSurface,
            isLoading: _isAppleLoading,
            onTap: _handleAppleSignIn,
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 48),

          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "OR",
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.38),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  thickness: 1,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 48),

          _buildPrimaryButton(
            onPressed: () => setState(() {
              _isLogin = true;
              _showEmailForm = true;
            }),
            text: "Sign in with password",
          ).animate().fadeIn(delay: 700.ms),

          const SizedBox(height: 40),

          _buildAuthToggleLink(),
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
            _isLogin ? "Welcome\nBack" : "Create\nAccount",
            style: GoogleFonts.outfit(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
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
                activeColor: Theme.of(context).colorScheme.onSurface,
                checkColor: Theme.of(context).colorScheme.surface,
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.38),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                "Remember me",
                style: GoogleFonts.outfit(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
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
                onPressed: () => context.go('/auth/forgot-password'),
                child: Text(
                  "Forgot the password?",
                  style: GoogleFonts.outfit(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 40),

          _buildSocialToggleRow(),

          const SizedBox(height: 48),

          _buildAuthToggleLink(),
        ],
      ),
    );
  }

  Widget _buildSocialToggleRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "social join",
                style: GoogleFonts.outfit(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.24),
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallSocialButton(
              FontAwesomeIcons.google,
              Colors.red,
              onTap: _handleGoogleSignIn,
              isLoading: _isGoogleLoading,
            ),
            const SizedBox(width: 24),
            _buildSmallSocialButton(
              FontAwesomeIcons.apple,
              Theme.of(context).colorScheme.onSurface,
              onTap: _handleAppleSignIn,
              isLoading: _isAppleLoading,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(icon, color: iconColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: GoogleFonts.outfit(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
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
    final String label = icon == FontAwesomeIcons.google ? 'Google' : 'Apple';
    return Semantics(
      button: true,
      label: 'Continue with $label',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 80,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  )
                : Center(child: FaIcon(icon, color: color, size: 24)),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          foregroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.surface,
              )
            : Text(
                text,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
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
      style: GoogleFonts.outfit(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        prefixIcon: Icon(
          icon,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.38),
          size: 20,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.38),
              )
            : null,
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.all(22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
          ),
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
            style: GoogleFonts.outfit(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: _isLogin ? "Sign up" : "Sign in",
                style: GoogleFonts.outfit(
                  color: Theme.of(context).colorScheme.onSurface,
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
