import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/components/common/driplord_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  Future<void> _handleResetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
      );
      if (mounted) {
        setState(() => _emailSent = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send reset email: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  LucideIcons.arrowLeft,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 32),
              Text(
                "FORGOT PASSWORD",
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
                "Recover your style pulse.",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),

              const SizedBox(height: 48),

              if (_emailSent) ...[
                // Success state
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
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
                          LucideIcons.mailCheck,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "LINK SENT",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "We've sent a recovery link to\n${_emailController.text}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.pop(),
                          child: const Text('BACK TO LOGIN'),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),
              ] else ...[
                // Email input
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                    prefixIcon: Icon(LucideIcons.mail, size: 18),
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 32),

                // Send button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('SEND RESET LINK'),
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 32),

                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      "Back to Login",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
