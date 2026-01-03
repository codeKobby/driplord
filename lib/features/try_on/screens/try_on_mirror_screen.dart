import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/mirror_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TryOnMirrorScreen extends ConsumerWidget {
  const TryOnMirrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mirrorItem = ref.watch(mirrorProvider);
    return Scaffold(
      backgroundColor: AppColors.pureBlack,
      body: Stack(
        children: [
          // Camera/Mirror Placeholder
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    mirrorItem?.imageUrl ??
                        "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000&auto=format&fit=crop",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: AppColors.pureBlack.withValues(alpha: 0.3)),
            ),
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleAvatar(
                    LucideIcons.x,
                    () => context.pop(),
                  ),
                  Text(
                    mirrorItem?.name ?? "Virtual Mirror",
                    style: GoogleFonts.outfit(
                      color: AppColors.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  _buildCircleAvatar(LucideIcons.refreshCcw, () {}),
                ],
              ),
            ),
          ),

          // AI Analysis Overlay
          Positioned(
            top: 150,
            left: 40,
            child: _buildAnalysisPoint("Shoulder Alignment", true),
          ),
          Positioned(
            top: 400,
            right: 40,
            child: _buildAnalysisPoint("Fit: Regular", false),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                _buildOutfitSelector(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMirrorAction(LucideIcons.camera, "Photo"),
                    _buildMirrorAction(LucideIcons.video, "Video"),
                    _buildMirrorAction(LucideIcons.share, "Share"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.pureBlack.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.24)),
        ),
        child: Icon(icon, color: AppColors.pureWhite, size: 20),
      ),
    );
  }

  Widget _buildAnalysisPoint(String label, bool isLeft) {
    return Row(
      children: [
        if (!isLeft) const SizedBox(width: 8),
        Container(height: 2, width: 40, color: AppColors.pureWhite.withValues(alpha: 0.54)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.pureWhite.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.24)),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(color: AppColors.pureWhite, fontSize: 12),
          ),
        ).animate().scale().fadeIn(),
      ],
    );
  }

  Widget _buildOutfitSelector() {
    return GlassCard(
      padding: const EdgeInsets.all(8),
      borderRadius: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOutfitThumb(
            "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=100",
          ),
          _buildOutfitThumb(
            "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=100",
          ),
          _buildOutfitThumb(
            "https://images.unsplash.com/photo-1539109132382-381bb3f1c2b3?w=100",
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.plus, color: AppColors.pureBlack, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitThumb(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(url)),
    );
  }

  Widget _buildMirrorAction(IconData icon, String label) {
    return Column(
      children: [
        _buildCircleAvatar(icon, () {}),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(color: AppColors.pureWhite.withValues(alpha: 0.7), fontSize: 12),
        ),
      ],
    );
  }
}
