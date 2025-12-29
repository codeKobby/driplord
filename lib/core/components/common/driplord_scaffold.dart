import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class DripLordScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool showAbstractShapes;

  const DripLordScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.showAbstractShapes = true,
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
          Container(color: AppColors.background),

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
                              const Color(
                                0xFFF5F0E8,
                              ).withOpacity(0.08), // Soft Beige
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
                              const Color(0xFF1C1C1C).withOpacity(0.3),
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
          SafeArea(child: body),
        ],
      ),
    );
  }
}
