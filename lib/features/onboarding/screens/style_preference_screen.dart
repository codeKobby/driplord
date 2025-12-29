import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/components/common/driplord_scaffold.dart';
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
    return DripLordScaffold(
      body: SafeArea(
        child: Padding(
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
                "What's your vibe?",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 8),
              Text(
                "Select styles tailored to you.",
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.white70),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 32),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _styles.length,
                  itemBuilder: (context, index) {
                    final style = _styles[index];
                    final isSelected = _selectedStyles.contains(style);

                    return GestureDetector(
                      onTap: () => _toggleStyle(style),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            style,
                            style: GoogleFonts.outfit(
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              fontSize: 16,
                              color: isSelected ? Colors.black : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ).animate().scale(delay: (index * 50).ms);
                  },
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
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
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
