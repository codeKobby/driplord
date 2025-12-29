import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/components/buttons/primary_button.dart';
import 'body_measurements_screen.dart';

class StylePreferenceScreen extends StatefulWidget {
  const StylePreferenceScreen({super.key});

  @override
  State<StylePreferenceScreen> createState() => _StylePreferenceScreenState();
}

class _StylePreferenceScreenState extends State<StylePreferenceScreen> {
  final List<String> _styles = [
    "Streetwear",
    "Minimalist",
    "Vintage",
    "Techwear",
    "Casual",
    "Formal",
    "Y2K",
    "Luxury",
  ];

  final Set<String> _selectedStyles = {};

  void _toggleStyle(String style) {
    setState(() {
      if (_selectedStyles.contains(style)) {
        _selectedStyles.remove(style);
      } else {
        _selectedStyles.add(style);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.background, Color(0xFF2E1065)],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: AppDimensions.paddingMd),
                  Text(
                    "What's your vibe?",
                    style: Theme.of(context).textTheme.displaySmall,
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 8),
                  Text(
                    "Select styles tailored to you.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: AppDimensions.paddingLg),

                  // Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppDimensions.paddingMd,
                            mainAxisSpacing: AppDimensions.paddingMd,
                            childAspectRatio: 1.5,
                          ),
                      itemCount: _styles.length,
                      itemBuilder: (context, index) {
                        final style = _styles[index];
                        final isSelected = _selectedStyles.contains(style);

                        return GestureDetector(
                          onTap: () => _toggleStyle(style),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryGlow
                                    : Colors.white.withValues(alpha: 0.1),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                style,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ).animate().scale(delay: (index * 50).ms);
                      },
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingLg),

                  // Next Button
                  PrimaryButton(
                    text: "Continue",
                    onPressed: _selectedStyles.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BodyMeasurementsScreen(),
                              ),
                            );
                          }
                        : null, // Disable if none selected
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
