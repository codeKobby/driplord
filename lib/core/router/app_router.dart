import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/weather_settings_screen.dart';
import '../../features/home/screens/notification_screen.dart';
import '../../features/home/screens/notification_detail_screen.dart';
import '../../features/home/screens/vibe_settings_screen.dart';
import '../../features/closet/screens/closet_screen.dart';
import '../../features/outfits/screens/outfits_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../components/common/fixed_app_bar.dart';
import '../components/navigation/floating_nav_bar.dart';

// Placeholder screens - to be implemented

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

class ClosetInsightsScreen extends StatefulWidget {
  const ClosetInsightsScreen({super.key});

  @override
  State<ClosetInsightsScreen> createState() => _ClosetInsightsScreenState();
}

class _ClosetInsightsScreenState extends State<ClosetInsightsScreen> {
  final List<NavItem> _navItems = const [
    NavItem(icon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.checkroom, label: 'Closet'),
    NavItem(icon: Icons.bookmark, label: 'Outfits'),
    NavItem(icon: Icons.person, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/closet');
        break;
      case 2:
        context.go('/outfits');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Closet Insights'),
      body: Stack(
        children: [
          const SafeArea(
            child: Center(child: Text('Closet Insights Screen')),
          ),
          FloatingNavBar(
            currentIndex: 1, // Closet tab
            onTap: _onNavTap,
            items: _navItems,
          ),
        ],
      ),
    );
  }
}

class UnwornItemsScreen extends StatefulWidget {
  const UnwornItemsScreen({super.key});

  @override
  State<UnwornItemsScreen> createState() => _UnwornItemsScreenState();
}

class _UnwornItemsScreenState extends State<UnwornItemsScreen> {
  final List<NavItem> _navItems = const [
    NavItem(icon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.checkroom, label: 'Closet'),
    NavItem(icon: Icons.bookmark, label: 'Outfits'),
    NavItem(icon: Icons.person, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/closet');
        break;
      case 2:
        context.go('/outfits');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Unworn Items'),
      body: Stack(
        children: [
          const SafeArea(
            child: Center(child: Text('Unworn Items Screen')),
          ),
          FloatingNavBar(
            currentIndex: 1, // Closet tab
            onTap: _onNavTap,
            items: _navItems,
          ),
        ],
      ),
    );
  }
}

class RecentItemsScreen extends StatefulWidget {
  const RecentItemsScreen({super.key});

  @override
  State<RecentItemsScreen> createState() => _RecentItemsScreenState();
}

class _RecentItemsScreenState extends State<RecentItemsScreen> {
  final List<NavItem> _navItems = const [
    NavItem(icon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.checkroom, label: 'Closet'),
    NavItem(icon: Icons.bookmark, label: 'Outfits'),
    NavItem(icon: Icons.person, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/closet');
        break;
      case 2:
        context.go('/outfits');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Recent Items'),
      body: Stack(
        children: [
          const SafeArea(
            child: Center(child: Text('Recent Items Screen')),
          ),
          FloatingNavBar(
            currentIndex: 1, // Closet tab
            onTap: _onNavTap,
            items: _navItems,
          ),
        ],
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
  const AddItemScreen({super.key, this.camera = false, this.gallery = false, this.url = false});

  final bool camera;
  final bool gallery;
  final bool url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Add Item'),
      body: Center(child: Text('Add Item Screen - Camera: $camera, Gallery: $gallery, URL: $url')),
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

class OutfitBuilderScreen extends StatelessWidget {
  const OutfitBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Build Outfit'),
      body: const Center(child: Text('Outfit Builder Screen')),
    );
  }
}

class StyleComposerScreen extends StatelessWidget {
  const StyleComposerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Style Composer'),
      body: const Center(child: Text('Style Composer Screen')),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Onboarding & Auth
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
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

    // Main Navigation
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/closet',
      builder: (context, state) => const ClosetScreen(),
    ),
    GoRoute(
      path: '/outfits',
      builder: (context, state) => const OutfitsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // Home Subpages
    GoRoute(
      path: '/home/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/home/notifications/:id',
      builder: (context, state) => NotificationDetailScreen(id: state.pathParameters['id']!),
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

    // Closet Subpages
    GoRoute(
      path: '/closet/item/:id',
      builder: (context, state) => ItemDetailScreen(id: state.pathParameters['id']!),
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

    // Outfits Subpages
    GoRoute(
      path: '/outfits/:id',
      builder: (context, state) => OutfitDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/outfits/create',
      builder: (context, state) => const OutfitBuilderScreen(),
    ),

    // Style Composer (Try-On)
    GoRoute(
      path: '/try-on',
      builder: (context, state) => const StyleComposerScreen(),
    ),
    GoRoute(
      path: '/try-on/item/:id',
      builder: (context, state) => const StyleComposerScreen(), // TODO: Pass mode parameters
    ),
    GoRoute(
      path: '/try-on/outfit/:id',
      builder: (context, state) => const StyleComposerScreen(), // TODO: Pass mode parameters
    ),
    GoRoute(
      path: '/try-on/compose',
      builder: (context, state) => const StyleComposerScreen(),
    ),
    GoRoute(
      path: '/try-on/ai/:vibe',
      builder: (context, state) => const StyleComposerScreen(), // TODO: Pass vibe parameter
    ),
  ],
);
