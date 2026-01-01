import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/components/common/fixed_app_bar.dart';
import '../../../core/theme/app_colors.dart';

enum Vibe {
  chill,
  bold,
  work,
  hype,
}

extension VibeExtension on Vibe {
  String get displayName {
    switch (this) {
      case Vibe.chill:
        return 'Chill';
      case Vibe.bold:
        return 'Bold';
      case Vibe.work:
        return 'Work';
      case Vibe.hype:
        return 'Hype';
    }
  }

  String get description {
    switch (this) {
      case Vibe.chill:
        return 'Relaxed, casual comfort';
      case Vibe.bold:
        return 'Confident, statement pieces';
      case Vibe.work:
        return 'Professional, polished';
      case Vibe.hype:
        return 'Trendy, attention-grabbing';
    }
  }

  IconData get icon {
    switch (this) {
      case Vibe.chill:
        return LucideIcons.cloud;
      case Vibe.bold:
        return LucideIcons.zap;
      case Vibe.work:
        return LucideIcons.briefcase;
      case Vibe.hype:
        return LucideIcons.star;
    }
  }

  Color get color {
    switch (this) {
      case Vibe.chill:
        return AppColors.success;
      case Vibe.bold:
        return AppColors.primary;
      case Vibe.work:
        return AppColors.info;
      case Vibe.hype:
        return AppColors.warning;
    }
  }

  String get aiReasoning {
    switch (this) {
      case Vibe.chill:
        return 'Based on your preference for neutral colors and comfortable fits in 70% of your outfits';
      case Vibe.bold:
        return 'Detected from your frequent selection of statement pieces and bright colors';
      case Vibe.work:
        return 'Learned from your Monday-Friday outfit choices and professional calendar events';
      case Vibe.hype:
        return 'Inspired by your weekend outfits and social media style preferences';
    }
  }
}

class VibeSettingsScreen extends StatefulWidget {
  const VibeSettingsScreen({super.key});

  @override
  State<VibeSettingsScreen> createState() => _VibeSettingsScreenState();
}

class _VibeSettingsScreenState extends State<VibeSettingsScreen> {
  Vibe _selectedVibe = Vibe.chill;

  // Mock data - in real app, this would come from AI analysis
  final Map<Vibe, int> _usageStats = {
    Vibe.chill: 45,
    Vibe.bold: 25,
    Vibe.work: 20,
    Vibe.hype: 10,
  };

  final Map<Vibe, double> _confidenceScores = {
    Vibe.chill: 0.95,
    Vibe.bold: 0.87,
    Vibe.work: 0.92,
    Vibe.hype: 0.78,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Style Vibes'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Your Style Vibes',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI-powered style recommendations based on your preferences',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // AI Insights Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AI Style Analysis',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your style preferences have been analyzed from 127 outfits over the past 3 months. Here are your personalized vibes:',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Vibe Selection
              Text(
                'Choose Your Vibe',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Vibe Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: Vibe.values.map((vibe) => _buildVibeCard(vibe)).toList(),
              ),

              const SizedBox(height: 32),

              // Selected Vibe Details
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _selectedVibe.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _selectedVibe.icon,
                            color: _selectedVibe.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedVibe.displayName,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                _selectedVibe.description,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Usage Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Usage',
                            '${_usageStats[_selectedVibe]}%',
                            Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            'Confidence',
                            '${(_confidenceScores[_selectedVibe]! * 100).round()}%',
                            Icons.verified,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // AI Reasoning
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.glassBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.brain,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI Reasoning',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedVibe.aiReasoning,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'Try This Vibe',
                            onPressed: () => _tryVibe(_selectedVibe),
                            icon: LucideIcons.play,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SecondaryButton(
                          text: 'Customize',
                          onPressed: () => _customizeVibe(_selectedVibe),
                          icon: LucideIcons.settings,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Recent Activity
              Text(
                'Recent Activity',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              _buildRecentActivity(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVibeCard(Vibe vibe) {
    final isSelected = _selectedVibe == vibe;
    final usage = _usageStats[vibe] ?? 0;
    final confidence = _confidenceScores[vibe] ?? 0.0;

    return GestureDetector(
      onTap: () => setState(() => _selectedVibe = vibe),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: vibe.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                vibe.icon,
                color: vibe.color,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            // Vibe name
            Text(
              vibe.displayName,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? vibe.color : AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // Usage percentage
            Text(
              '$usage% used',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 8),

            // Confidence indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: vibe.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 12,
                    color: vibe.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(confidence * 100).round()}%',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: vibe.color,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected) ...[
              const SizedBox(height: 12),
              Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: vibe.color,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ],
        ),
      ).animate(target: isSelected ? 1.0 : 0.0)
       .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0))
       .elevation(begin: 0, end: 4),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {'action': 'Generated', 'vibe': 'Chill', 'time': '2 hours ago'},
      {'action': 'Customized', 'vibe': 'Work', 'time': '1 day ago'},
      {'action': 'Used', 'vibe': 'Bold', 'time': '3 days ago'},
      {'action': 'Updated', 'vibe': 'Hype', 'time': '1 week ago'},
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.activity,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${activity['action']} ${activity['vibe']} vibe',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                activity['time'] as String,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _tryVibe(Vibe vibe) {
    // Navigate to try-on with the selected vibe
    context.go('/try-on/ai/${vibe.name}');
  }

  void _customizeVibe(Vibe vibe) {
    // Navigate to customization screen
    context.go('/home/vibes/customize');
  }
}
