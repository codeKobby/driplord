import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import '../../../core/constants/app_dimensions.dart';
import 'style_preference_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Your AI Stylist",
      "subtitle":
          "Get daily outfit recommendations based on your vibe, weather, and occasion.",
      "icon": LucideIcons.sparkles,
      "graphicType": "stylist",
    },
    {
      "title": "Digital Wardrobe",
      "subtitle":
          "Scan your closet in seconds. Organize, categorize, and never say 'I have nothing to wear'.",
      "icon": LucideIcons.shirt,
      "graphicType": "wardrobe",
    },
    {
      "title": "Virtual Try-On",
      "subtitle":
          "See how it fits before you buy. Visualize outfits on your body with AI.",
      "icon": LucideIcons.camera,
      "graphicType": "tryon",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final item = _onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXl,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Dynamic Graphic
                      SizedBox(
                        height: 320,
                        width: 320,
                        child: _OnboardingGraphic(
                          type: item["graphicType"],
                          icon: item["icon"],
                        ),
                      ),
                      const SizedBox(height: 64),

                      // Typography
                      Text(
                            item["title"] ?? "",
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  height: 1.1,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 16),

                      Text(
                            item["subtitle"] ?? "",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                  fontSize: 16,
                                ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 600.ms)
                          .slideY(begin: 0.1, end: 0),

                      const Spacer(),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Section
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingXl),
            child: Column(
              children: [
                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Semantics(
                      label:
                          'Go to page ${index + 1} of ${_onboardingData.length}',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        borderRadius: BorderRadius.circular(2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          width: _currentPage == index
                              ? 32
                              : 12, // More refined pill shape
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: _currentPage == _onboardingData.length - 1
                        ? "Get Started"
                        : "Next",
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StylePreferenceScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingGraphic extends StatelessWidget {
  final String type;
  final IconData icon;

  const _OnboardingGraphic({required this.type, required this.icon});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'wardrobe':
        return Stack(
          alignment: Alignment.center,
          children: [
            // Fan Card 1 - Left
            Transform.rotate(
              angle: -0.2,
              child: _GlassCardPreview(
                color: AppColors.surfaceLight.withValues(alpha: 0.5),
              ),
            ).animate().slideX(
              begin: 0.2,
              end: -20,
              duration: 800.ms,
              curve: Curves.easeOutBack,
            ),

            // Fan Card 2 - Right
            Transform.rotate(
              angle: 0.2,
              child: _GlassCardPreview(
                color: AppColors.surfaceLight.withValues(alpha: 0.5),
              ),
            ).animate().slideX(
              begin: -0.2,
              end: 20,
              duration: 800.ms,
              delay: 100.ms,
              curve: Curves.easeOutBack,
            ),

            // Center Card
            const _GlassCardPreview(
                  child: Icon(
                    LucideIcons.shirt,
                    size: 64,
                    color: AppColors.textPrimary,
                  ),
                )
                .animate()
                .scale(duration: 800.ms, curve: Curves.easeOutBack)
                .shimmer(delay: 1.seconds, duration: 2.seconds),
          ],
        );

      case 'tryon':
        return Stack(
          alignment: Alignment.center,
          children: [
            // Scanner Frame
            Container(
              width: 200,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Scanning Bar
                  Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary,
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .slideY(begin: 0, end: 140, duration: 2.seconds),
                ],
              ),
            ).animate().fadeIn(),

            // Center Icon
            const Icon(
              LucideIcons.user,
              size: 80,
              color: AppColors.textSecondary,
            ).animate().fadeIn(),
          ],
        );

      case 'stylist':
      default:
        return Stack(
          alignment: Alignment.center,
          children: [
            // Abstract Circle Bg
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),

            // Floating Stars
            Positioned(
              top: 40,
              right: 40,
              child:
                  Icon(LucideIcons.sparkles, size: 24, color: AppColors.primary)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(0.5, 0.5)),
            ),
            Positioned(
              bottom: 60,
              left: 50,
              child:
                  Icon(
                        LucideIcons.star,
                        size: 16,
                        color: AppColors.textSecondary,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(0.8, 0.8), delay: 500.ms),
            ),

            // Center Icon with Glass Glow
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.glassSurface,
                border: Border.all(color: AppColors.glassBorder),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.bot,
                size: 64,
                color: AppColors.textPrimary,
              ),
            ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms),
          ],
        );
    }
  }
}

class _GlassCardPreview extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const _GlassCardPreview({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        color: color ?? AppColors.glassSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
