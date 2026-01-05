import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      LucideIcons.arrowLeft,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),

          // Icon Group
          Center(
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              child: Icon(
                LucideIcons.lock,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),

          const SizedBox(height: 48),

          Text(
            "ACCESS YOUR STYLE",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            "Your digital wardrobe awaits.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 64),

          // Social Buttons
          _buildSocialButton(
            icon: FontAwesomeIcons.google,
            label: "Continue with Google",
            iconColor: Colors.red,
            isLoading: _isGoogleLoading,
            onTap: _handleGoogleSignIn,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 12),

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
                  ).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "OR",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _isLogin = true;
                _showEmailForm = true;
              }),
              child: const Text("SIGN IN WITH PASSWORD"),
            ),
          ).animate().fadeIn(delay: 700.ms),

          const SizedBox(height: 40),

          _buildAuthToggleLink(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEmailForm() {
    return SingleChildScrollView(
      key: const ValueKey('email_form'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            _isLogin ? "WELCOME\nBACK" : "CREATE\nACCOUNT",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 8),
          Text(
            _isLogin ? "Your style is ready." : "Start your journey.",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

          const SizedBox(height: 48),

          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _emailController,
                  hint: "Email address",
                  icon: LucideIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordController,
                  hint: "Password",
                  icon: LucideIcons.lock,
                  isPassword: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (_isLogin) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/auth/forgot-password'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Forgot password?",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          _buildPrimaryButton(
            onPressed: _handleEmailAuth,
            text: _isLogin ? "SIGN IN" : "SIGN UP",
            isLoading: _isLoading,
          ),

          const SizedBox(height: 48),

          _buildSocialToggleRow(),

          const SizedBox(height: 48),

          _buildAuthToggleLink(),
          const SizedBox(height: 32),
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
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "ALTERNATIVE JOIN",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
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
            const SizedBox(width: 16),
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
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
                        color: Theme.of(context).colorScheme.primary,
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
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
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
    final String label = icon == FontAwesomeIcons.google
        ? 'Continue with Google'
        : 'Continue with Apple';

    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : Center(child: FaIcon(icon, color: color, size: 22)),
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
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : Text(text),
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
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: 18,
                ),
              )
            : null,
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
            text: _isLogin ? "New to DripLord? " : "Already styled? ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            children: [
              TextSpan(
                text: _isLogin ? "Join now" : "Sign in",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
