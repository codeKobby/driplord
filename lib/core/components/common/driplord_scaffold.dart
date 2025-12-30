import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DripLordScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool showAbstractShapes;
  final bool useSafeArea;

  const DripLordScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.showAbstractShapes = true,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          // Base Background
          Container(color: Theme.of(context).scaffoldBackgroundColor),

          // Abstract Luxury Orbs
          if (showAbstractShapes) ...[
            // Top Left Orb (Warm Luxury Glow)
            Positioned(
              top: -150,
              left: -150,
              child:
                  Container(
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              (Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFFF5F0E8)
                                      : Theme.of(context).colorScheme.primary)
                                  .withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        duration: 8.seconds,
                        begin: const Offset(1, 1),
                        end: const Offset(1.3, 1.3),
                      ),
            ),

            // Bottom Right (Minimal Grey Glow)
            Positioned(
              bottom: -200,
              right: -100,
              child:
                  Container(
                        width: 600,
                        height: 600,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              (Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF1C1C1C)
                                      : Theme.of(context).colorScheme.secondary)
                                  .withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        duration: 10.seconds,
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(1, 1),
                      ),
            ),
          ],

          // Main Content
          useSafeArea ? SafeArea(child: body) : body,
        ],
      ),
    );
  }
}
