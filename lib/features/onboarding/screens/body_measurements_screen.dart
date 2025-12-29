import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/components/common/driplord_scaffold.dart';
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
    return DripLordScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
            Text(
              "Your Stats",
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ).animate().fadeIn().slideX(),
            const SizedBox(height: 8),
            Text(
              "This helps AI predict how clothes fit.",
              style: GoogleFonts.outfit(fontSize: 16, color: Colors.white70),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 48),

            // Gender Selection
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: ['Male', 'Female', 'Other'].map((gender) {
                  final isSelected = _selectedGender == gender;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGender = gender),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            gender,
                            style: GoogleFonts.outfit(
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: isSelected ? Colors.black : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 40),

            _buildSliderCard(
              title: "Height",
              value: "${_height.round()} cm",
              slider: Slider(
                value: _height,
                min: 140,
                max: 220,
                activeColor: Colors.white,
                inactiveColor: Colors.white10,
                onChanged: (val) => setState(() => _height = val),
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 24),

            _buildSliderCard(
              title: "Weight",
              value: "${_weight.round()} kg",
              slider: Slider(
                value: _weight,
                min: 40,
                max: 150,
                activeColor: Colors.white,
                inactiveColor: Colors.white10,
                onChanged: (val) => setState(() => _weight = val),
              ),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  "Finish Setup",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required String value,
    required Widget slider,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          slider,
        ],
      ),
    );
  }
}
