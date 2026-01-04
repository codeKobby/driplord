import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/scan_clothes_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';

import '../../features/home/screens/weather_settings_screen.dart';
import '../../features/home/screens/notification_screen.dart';
import '../../features/closet/screens/closet_screen.dart';
import '../../features/outfits/screens/outfits_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../components/common/fixed_app_bar.dart';

import '../../features/home/screens/daily_hub_screen.dart';
import '../../features/home/screens/main_scaffold.dart';
import '../../features/home/screens/frequently_worn_screen.dart';
import '../../features/home/screens/newly_added_screen.dart';
import '../../features/home/screens/neglected_screen.dart';
import '../../features/try_on/screens/style_composer_screen.dart';

// =============================================================================
// PLACEHOLDER SCREENS (Simple - no nav bar needed since outside shell route)
// =============================================================================

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Notification Details'),
      body: Center(child: Text('Notification Detail: $id')),
    );
  }
}

class VibeSettingsScreen extends StatelessWidget {
  const VibeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Vibe Settings'),
      body: const Center(child: Text('Vibe Settings Screen')),
    );
  }
}

class VibeCustomizationScreen extends StatelessWidget {
  const VibeCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Customize Vibe'),
      body: const Center(child: Text('Vibe Customization Screen')),
    );
  }
}

class ClosetInsightsScreen extends StatelessWidget {
  const ClosetInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Closet Insights'),
      body: const SafeArea(
        child: Center(child: Text('Closet Insights Screen')),
      ),
    );
  }
}

class UnwornItemsScreen extends StatelessWidget {
  const UnwornItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Unworn Items'),
      body: const SafeArea(child: Center(child: Text('Unworn Items Screen'))),
    );
  }
}

class RecentItemsScreen extends StatelessWidget {
  const RecentItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Recently Added'),
      body: const SafeArea(
        child: Center(child: Text('Recently Added Items Screen')),
      ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Item Details'),
      body: Center(child: Text('Item Detail: $id')),
    );
  }
}

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({
    super.key,
    this.camera = false,
    this.gallery = false,
    this.url = false,
  });

  final bool camera;
  final bool gallery;
  final bool url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Add Item'),
      body: Center(
        child: Text(
          'Add Item Screen - Camera: $camera, Gallery: $gallery, URL: $url',
        ),
      ),
    );
  }
}

class OutfitDetailScreen extends StatelessWidget {
  const OutfitDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Outfit Details'),
      body: Center(child: Text('Outfit Detail: $id')),
    );
  }
}

// =============================================================================
// ROUTER CONFIGURATION
// =============================================================================

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // =========================================================================
    // ONBOARDING & AUTH ROUTES (Fullscreen, no nav bar)
    // =========================================================================
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/onboarding/scan',
      builder: (context, state) => const ScanClothesScreen(),
    ),
    GoRoute(
      path: '/auth/signin',
      builder: (context, state) => const AuthScreen(initialIsLogin: true),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const AuthScreen(initialIsLogin: false),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // =========================================================================
    // MAIN APP SHELL (Bottom nav visible on these 4 tabs ONLY)
    // Per Apple HIG & Material Design 3: Nav bar for top-level destinations
    // =========================================================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home (DailyHubScreen)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const DailyHubScreen(),
            ),
          ],
        ),

        // Tab 2: Closet
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/closet',
              builder: (context, state) => const ClosetScreen(),
            ),
          ],
        ),

        // Tab 3: Outfits
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/outfits',
              builder: (context, state) => const OutfitsScreen(),
            ),
          ],
        ),

        // Tab 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // =========================================================================
    // SUBPAGES (Fullscreen, NO nav bar - per Apple HIG & Material Design 3)
    // These are detail/settings screens that should hide the bottom nav
    // =========================================================================

    // --- Home Subpages ---
    GoRoute(
      path: '/home/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/home/notifications/:id',
      builder: (context, state) =>
          NotificationDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/home/weather',
      builder: (context, state) => const WeatherSettingsScreen(),
    ),
    GoRoute(
      path: '/home/vibes',
      builder: (context, state) => const VibeSettingsScreen(),
    ),
    GoRoute(
      path: '/home/vibes/customize',
      builder: (context, state) => const VibeCustomizationScreen(),
    ),

    // --- Closet Subpages ---
    GoRoute(
      path: '/closet/item/:id',
      builder: (context, state) =>
          ItemDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/closet/add',
      builder: (context, state) => const AddItemScreen(),
    ),
    GoRoute(
      path: '/closet/add/camera',
      builder: (context, state) => const AddItemScreen(camera: true),
    ),
    GoRoute(
      path: '/closet/add/gallery',
      builder: (context, state) => const AddItemScreen(gallery: true),
    ),
    GoRoute(
      path: '/closet/add/url',
      builder: (context, state) => const AddItemScreen(url: true),
    ),
    GoRoute(
      path: '/closet/insights',
      builder: (context, state) => const ClosetInsightsScreen(),
    ),
    GoRoute(
      path: '/closet/insights/unworn',
      builder: (context, state) => const UnwornItemsScreen(),
    ),
    GoRoute(
      path: '/closet/insights/recent',
      builder: (context, state) => const RecentItemsScreen(),
    ),
    GoRoute(
      path: '/home/newly-added',
      builder: (context, state) => const NewlyAddedScreen(),
    ),
    GoRoute(
      path: '/home/neglected',
      builder: (context, state) => const NeglectedScreen(),
    ),
    GoRoute(
      path: '/home/frequently-worn',
      builder: (context, state) => const FrequentlyWornScreen(),
    ),

    // --- Outfits Subpages ---
    GoRoute(
      path: '/outfits/create',
      builder: (context, state) =>
          const StyleComposerScreen(mode: ComposerMode.manual),
    ),
    GoRoute(
      path: '/outfits/:id',
      builder: (context, state) =>
          OutfitDetailScreen(id: state.pathParameters['id']!),
    ),

    // --- Try-On / Style Composer (Fullscreen) ---
    // Note: ComposerMode enum is defined in style_composer_screen.dart
    GoRoute(
      path: '/try-on',
      builder: (context, state) =>
          const StyleComposerScreen(mode: ComposerMode.manual),
    ),
    GoRoute(
      path: '/try-on/item/:id',
      builder: (context, state) => StyleComposerScreen(
        mode: ComposerMode.tryOn,
        initialItemId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/try-on/outfit/:id',
      builder: (context, state) {
        // Check extra query param to distinguish 'view' vs 'edit' if needed
        // For now default to 'view', user can toggle to edit in UI
        return StyleComposerScreen(
          mode: ComposerMode.view,
          outfitId: state.pathParameters['id'],
        );
      },
    ),
    GoRoute(
      path: '/try-on/edit/:id',
      builder: (context, state) => StyleComposerScreen(
        mode: ComposerMode.edit,
        outfitId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/try-on/compose',
      builder: (context, state) =>
          const StyleComposerScreen(mode: ComposerMode.manual),
    ),
    GoRoute(
      path: '/try-on/ai/:vibe',
      builder: (context, state) => StyleComposerScreen(
        mode: ComposerMode.ai,
        vibe: state.pathParameters['vibe'],
      ),
    ),
  ],
);
