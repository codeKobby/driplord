import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/constants/app_dimensions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Your AI Stylist",
      "subtitle":
          "Get daily outfit recommendations based on your vibe, weather, and occasion.",
    },
    {
      "title": "Digital Wardrobe",
      "subtitle":
          "Scan your closet in seconds. Organize, categorize, and never say 'I have nothing to wear'.",
    },
    {
      "title": "Virtual Try-On",
      "subtitle":
          "See how it fits before you buy. Visualize outfits on your body with AI.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  Color(0xFF1E1B2E), // Slightly lighter bottom
                ],
              ),
            ),
          ),

          // Content
          Column(
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
                      padding: const EdgeInsets.all(AppDimensions.paddingLg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Graphic Placeholder (Circle with Glow)
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 100,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.checkroom,
                                size: 100,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),

                          const SizedBox(height: 64),

                          Text(
                            item["title"]!,
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ).animate().fadeIn().slideY(begin: 0.3, end: 0),

                          const SizedBox(height: 16),

                          Text(
                                item["subtitle"]!,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.3, end: 0),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicators & Button
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLg),
                child: Column(
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.3,
                                  ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: _currentPage == _onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                      onPressed: () {
                        if (_currentPage < _onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Navigate to auth instead of onboarding
                          context.go('/auth/signin');
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Skip/Login option
                    if (_currentPage < _onboardingData.length - 1)
                      TextButton(
                        onPressed: () => context.go('/auth/signin'),
                        child: Text(
                          "Skip",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                    const SizedBox(height: AppDimensions.paddingLg),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
