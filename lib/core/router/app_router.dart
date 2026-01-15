import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';

import '../../features/home/screens/weather_settings_screen.dart';
import '../../features/home/screens/notification_screen.dart';
import '../../features/closet/screens/closet_screen.dart';
import '../../features/closet/screens/add_item_screen.dart';
import '../../features/closet/screens/closet_item_detail_screen.dart';

import '../../features/outfits/screens/outfits_screen.dart';
import '../../features/outfits/screens/outfit_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../components/common/fixed_app_bar.dart';

import '../../features/home/screens/daily_hub_screen.dart';
import '../../features/home/screens/style_calendar_screen.dart';
import '../../features/home/screens/main_scaffold.dart';
import '../../features/home/screens/frequently_worn_screen.dart';
import '../../features/home/screens/newly_added_screen.dart';
import '../../features/home/screens/neglected_screen.dart';
import '../../features/try_on/screens/professional_canvas_screen.dart';
import '../../features/stylist/screens/stylist_chat_screen.dart';
import '../../features/try_on/models/outfit_item.dart';

import '../../features/home/screens/newly_added_item_detail_screen.dart';
import '../../features/home/screens/neglected_item_detail_screen.dart';
import '../../features/home/screens/frequently_worn_item_detail_screen.dart';
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

// =============================================================================
// ROUTER CONFIGURATION
// =============================================================================

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    final bool isAuthenticated =
        Supabase.instance.client.auth.currentSession != null;

    // If authenticated and on welcome screen, redirect to home
    if (isAuthenticated && state.uri.path == '/') {
      return '/home';
    }

    // Define protected routes (main app routes that require authentication)
    final protectedRoutes = [
      '/home',
      '/closet',
      '/outfits',
      '/profile',
      '/try-on',
    ];

    // Check if current location is a protected route
    final isProtectedRoute = protectedRoutes.any(
      (route) => state.uri.path.startsWith(route),
    );

    // If trying to access protected route without authentication, redirect to sign in
    if (isProtectedRoute && !isAuthenticated) {
      return '/auth/signin';
    }

    // If authenticated and trying to access auth routes, redirect to home
    if (isAuthenticated && state.uri.path.startsWith('/auth/')) {
      return '/home';
    }

    return null; // No redirect needed
  },
  routes: [
    // =========================================================================
    // WELCOME SCREEN (Intro page - no nav bar)
    // =========================================================================
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),

    // =========================================================================
    // AUTH ROUTES (Fullscreen, no nav bar)
    // =========================================================================
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
    GoRoute(
      path: '/stylist',
      builder: (context, state) => const StylistChatScreen(),
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
    GoRoute(
      path: '/home/calendar',
      builder: (context, state) => const StyleCalendarScreen(),
    ),

    GoRoute(
      path: '/closet/add',
      builder: (context, state) => const AddItemScreen(),
    ),
    GoRoute(
      path: '/closet/add/camera/:path',
      builder: (context, state) {
        final path = Uri.decodeComponent(state.pathParameters['path']!);
        return AddItemScreen(imagePath: path, source: 'camera');
      },
    ),
    GoRoute(
      path: '/closet/add/gallery/:path',
      builder: (context, state) {
        final path = Uri.decodeComponent(state.pathParameters['path']!);
        return AddItemScreen(imagePath: path, source: 'gallery');
      },
    ),
    GoRoute(
      path: '/closet/add/url/:url',
      builder: (context, state) {
        final url = Uri.decodeComponent(state.pathParameters['url']!);
        return AddItemScreen(initialUrl: url);
      },
    ),
    GoRoute(
      path: '/closet/item/:id',
      builder: (context, state) =>
          ClosetItemDetailScreen(itemId: state.pathParameters['id']!),
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
    GoRoute(
      path: '/home/newly-added/item/:id',
      builder: (context, state) =>
          NewlyAddedItemDetailScreen(itemId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/home/neglected/item/:id',
      builder: (context, state) =>
          NeglectedItemDetailScreen(itemId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/home/frequently-worn/item/:id',
      builder: (context, state) =>
          FrequentlyWornItemDetailScreen(itemId: state.pathParameters['id']!),
    ),

    // --- Outfits Subpages ---
    GoRoute(
      path: '/outfits/create',
      builder: (context, state) =>
          const ProfessionalCanvasScreen(mode: ComposerMode.manual),
    ),
    GoRoute(
      path: '/outfits/:id',
      builder: (context, state) =>
          OutfitDetailScreen(id: state.pathParameters['id']!),
    ),

    // --- Try-On / Style Composer (Fullscreen) ---
    // Note: ComposerMode enum is defined in professional_canvas_screen.dart
    GoRoute(
      path: '/try-on',
      builder: (context, state) => ProfessionalCanvasScreen(
        mode: ComposerMode.manual,
        initialItems: state.extra as List<OutfitStackItem>?,
      ),
    ),
    GoRoute(
      path: '/try-on/item/:id',
      builder: (context, state) => ProfessionalCanvasScreen(
        mode: ComposerMode.tryOn,
        initialItemId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/try-on/outfit/:id',
      builder: (context, state) {
        // Check extra query param to distinguish 'view' vs 'edit' if needed
        // For now default to 'view', user can toggle to edit in UI
        return ProfessionalCanvasScreen(
          mode: ComposerMode.view,
          outfitId: state.pathParameters['id'],
        );
      },
    ),
    GoRoute(
      path: '/try-on/edit/:id',
      builder: (context, state) => ProfessionalCanvasScreen(
        mode: ComposerMode.edit,
        outfitId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/try-on/compose',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ProfessionalCanvasScreen(
          mode: ComposerMode.manual,
          scheduledDate: extra?['scheduledDate'] as DateTime?,
          eventTitle: extra?['eventTitle'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/try-on/ai/:vibe',
      builder: (context, state) => ProfessionalCanvasScreen(
        mode: ComposerMode.ai,
        vibe: state.pathParameters['vibe'],
      ),
    ),
  ],
);
