import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/cards/glass_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import '../providers/preferences_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final prefs = ref.watch(preferencesProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          floating: true,
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineLarge,
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
                    "${prefs.height}, ${prefs.weight}",
                  ),
                  _MenuItem(
                    LucideIcons.palette,
                    "Style Preferences",
                    prefs.styles.join(", "),
                  ),
                ]),
                const SizedBox(height: 24),
                // App Settings Section (Merged from Settings)
                _buildMenuSection(context, "App Settings", [
                  _MenuItem(LucideIcons.globe, "Language", "English (US)"),
                  _MenuItem(LucideIcons.database, "Cloud Sync", "Enabled"),
                ]),
                const SizedBox(height: 24),

                _buildMenuSection(context, "Privacy & Security", [
                  _MenuItem(LucideIcons.shield, "Privacy Policy", null),
                  _MenuItem(
                    LucideIcons.camera,
                    "Camera Permissions",
                    "Authorized",
                  ),
                  _MenuItem(
                    LucideIcons.image,
                    "Gallery Access",
                    "Always Allow",
                  ),
                ]),
                const SizedBox(height: 24),

                _buildMenuSection(context, "Support", [
                  _MenuItem(LucideIcons.helpCircle, "Help Center", null),
                  _MenuItem(LucideIcons.mail, "Contact Stylist", null),
                  _MenuItem(LucideIcons.info, "About DripLord v1.0.0", null),
                ]),
                const SizedBox(height: 40),
                _buildSignOutButton(context, ref),
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
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          "Fashion Enthusiast",
          style: Theme.of(context).textTheme.bodyMedium,
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
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
            style: Theme.of(context).textTheme.labelMedium,
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: entry.value.subtitle != null
                        ? Text(
                            entry.value.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async {
          await Supabase.instance.client.auth.signOut();
          if (context.mounted) {
            context.go('/');
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "Sign Out",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
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
