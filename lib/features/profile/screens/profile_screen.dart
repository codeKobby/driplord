import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/cards/glass_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          floating: true,
          title: Text(
            "Profile",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildProfileHeader(context),
                const SizedBox(height: 40),

                // Preferences Section
                _buildMenuSection(context, "Preferences", [
                  _MenuItem(
                    LucideIcons.moon,
                    "Dark Mode",
                    isDark
                        ? "Enable for luxury vibes"
                        : "Disable for light mode",
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) {
                        ref
                            .read(themeProvider.notifier)
                            .toggle(val ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.24),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                _buildMenuSection(context, "Style & Fit", [
                  _MenuItem(
                    LucideIcons.ruler,
                    "Body Measurements",
                    "Updated 2 weeks ago",
                  ),
                  _MenuItem(
                    LucideIcons.palette,
                    "Style Preferences",
                    "Streetwear, Minimalist",
                  ),
                ]),
                const SizedBox(height: 24),
                _buildMenuSection(context, "Account", [
                  _MenuItem(LucideIcons.shield, "Privacy & Data", null),
                  _MenuItem(LucideIcons.bell, "Notifications", "All enabled"),
                ]),
                const SizedBox(height: 40),
                _buildSignOutButton(context),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.24),
                    Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Icon(
                  LucideIcons.user,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.camera,
                  size: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Kobby",
          style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "Fashion Enthusiast",
          style: GoogleFonts.outfit(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.54),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatCard(context, "128", "Items"),
            const SizedBox(width: 16),
            _buildStatCard(context, "45", "Outfits"),
            const SizedBox(width: 16),
            _buildStatCard(context, "12", "Faves"),
          ],
        ),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<_MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.38),
              letterSpacing: 1.2,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      entry.value.icon,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    title: Text(
                      entry.value.title,
                      style: GoogleFonts.outfit(fontSize: 16),
                    ),
                    subtitle: entry.value.subtitle != null
                        ? Text(
                            entry.value.subtitle!,
                            style: GoogleFonts.outfit(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.38),
                              fontSize: 12,
                            ),
                          )
                        : null,
                    trailing:
                        entry.value.trailing ??
                        Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.24),
                        ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async {
          await Supabase.instance.client.auth.signOut();
          if (context.mounted) Navigator.pushReplacementNamed(context, '/');
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "Sign Out",
          style: GoogleFonts.outfit(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  _MenuItem(this.icon, this.title, this.subtitle, {this.trailing});
}
