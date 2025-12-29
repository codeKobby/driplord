import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../auth/screens/auth_screen.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  const BodyMeasurementsScreen({super.key});

  @override
  State<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> {
  String _selectedGender = 'Male';
  double _height = 175.0; // cm
  double _weight = 70.0; // kg

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: AppDimensions.paddingMd),
                  Text(
                    "Your Stats",
                    style: Theme.of(context).textTheme.displaySmall,
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 8),
                  Text(
                    "This helps AI predict how clothes fit.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 40),

                  // Gender Selection
                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['Male', 'Female', 'Other'].map((gender) {
                        final isSelected = _selectedGender == gender;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedGender = gender),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              gender,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 32),

                  // Height Slider
                  Text(
                    "Height: ${_height.round()} cm",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _height,
                    min: 140,
                    max: 220,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.surface,
                    onChanged: (val) => setState(() => _height = val),
                  ),

                  const SizedBox(height: 24),

                  // Weight Slider
                  Text(
                    "Weight: ${_weight.round()} kg",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _weight,
                    min: 40,
                    max: 150,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.surface,
                    onChanged: (val) => setState(() => _weight = val),
                  ),

                  const SizedBox(height: 60),

                  PrimaryButton(
                    text: "Finish Setup",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    },
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
