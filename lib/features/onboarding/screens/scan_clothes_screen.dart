import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import '../../closet/providers/closet_provider.dart';

class ScanClothesScreen extends ConsumerStatefulWidget {
  const ScanClothesScreen({super.key});

  @override
  ConsumerState<ScanClothesScreen> createState() => _ScanClothesScreenState();
}

class _ScanClothesScreenState extends ConsumerState<ScanClothesScreen> {
  // Mock steps for the scanning process
  final List<String> _steps = [
    "Connecting to visual cortex...",
    "Scanning wardrobe...",
    "Identifying fabrics...",
    "Analyzing color palette...",
    "Categorizing items...",
    "Building style profile...",
  ];

  int _currentStep = 0;
  double _progress = 0.0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  Future<void> _startScanning() async {
    // Simulate the scanning steps
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;

      setState(() {
        _currentStep = i;
        _progress = (i + 1) / _steps.length;
      });

      // Random delay for realism
      await Future.delayed(Duration(milliseconds: 800 + (500 * (i % 2))));
    }

    if (!mounted) return;

    setState(() {
      _isComplete = true;
    });

    // "Find" and add checks
    await Future.delayed(const Duration(milliseconds: 500));

    _finishOnboarding();
  }

  void _finishOnboarding() {
    // Add the mock items to the closet
    ref.read(closetProvider.notifier).addItems(ClosetNotifier.mockItems);

    // Navigate to home after a brief success moment
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Scanner Animation
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing Rings
                      ...List.generate(3, (index) {
                        return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .scale(
                              duration: 2000.ms,
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1.5, 1.5),
                              delay: (index * 600).ms,
                              curve: Curves.easeInOut,
                            )
                            .fadeOut(
                              duration: 2000.ms,
                              delay: (index * 600).ms,
                              curve: Curves.easeInOut,
                            );
                      }),

                      // Central Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child:
                            Icon(
                                  _isComplete
                                      ? LucideIcons.check
                                      : LucideIcons.scanLine,
                                  size: 48,
                                  color: _isComplete
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.primary,
                                )
                                .animate(target: _isComplete ? 1 : 0)
                                .scale(
                                  duration: 300.ms,
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.2, 1.2),
                                )
                                .then()
                                .scale(
                                  begin: const Offset(1.2, 1.2),
                                  end: const Offset(1, 1),
                                ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Text Updates
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  _isComplete ? "Style Profile Ready" : _steps[_currentStep],
                  key: ValueKey<String>(
                    _isComplete ? "done" : _steps[_currentStep],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                _isComplete
                    ? "Your AI stylist is synced."
                    : "Keep the app open while we analyze your vibe.",
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Progress Bar
              if (!_isComplete)
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 500),
                        widthFactor: _progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
