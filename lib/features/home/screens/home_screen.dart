import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/components/navigation/floating_nav_bar.dart';
import 'daily_hub_screen.dart';
import '../../closet/screens/closet_screen.dart';
import '../../closet/screens/add_item_screen.dart';
import '../../outfits/screens/outfits_screen.dart';
import '../../outfits/screens/outfit_builder_screen.dart';
import '../../profile/screens/profile_screen.dart';

import '../../../core/components/common/driplord_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<NavItem> _navItems = const [
    NavItem(icon: LucideIcons.home, label: 'Home'),
    NavItem(icon: LucideIcons.shirt, label: 'Closet'),
    NavItem(icon: LucideIcons.bookmark, label: 'Outfits'),
    NavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      useSafeArea: false,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              DailyHubScreen(),
              ClosetScreen(),
              OutfitsScreen(),
              ProfileScreen(),
            ],
          ),

          // Context-aware FAB
          _buildContextAwareFAB(),

          FloatingNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            items: _navItems,
          ),
        ],
      ),
    );
  }

  Widget _buildContextAwareFAB() {
    IconData icon;
    String label;
    VoidCallback onPressed;

    switch (_currentIndex) {
      case 0:
        icon = FontAwesomeIcons.shirt;
        label = "Stylist";
        onPressed = () => _showGenerateOptions();
        break;
      case 1:
        icon = LucideIcons.plus;
        label = "Add Item";
        onPressed = () => _showAddItemOptions();
        break;
      case 2:
        icon = LucideIcons.plusCircle;
        label = "New Outfit";
        onPressed = () => _showCreateOutfitOptions();
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned(
      right: 32,
      bottom: 120, // Positioned above the Nav Bar
      child:
          FloatingActionButton.extended(
                onPressed: onPressed,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(icon),
                label: Text(label),
              )
              .animate(key: ValueKey(_currentIndex))
              .fadeIn()
              .slideY(begin: 1.0, end: 0.0),
    );
  }

  void _showGenerateOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGlassBottomSheet(
        title: "Generate New Look",
        options: [
          _BottomSheetOption(LucideIcons.sparkles, "AI Recommendation", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI Recommendation coming soon...")),
            );
          }),
          _BottomSheetOption(LucideIcons.calendar, "For an Event", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Event-based looks coming soon...")),
            );
          }),
          _BottomSheetOption(LucideIcons.cloud, "Weather Based", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Weather integration coming soon..."),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showAddItemOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGlassBottomSheet(
        title: "Add Clothing",
        options: [
          _BottomSheetOption(LucideIcons.camera, "Take Photo", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            );
          }),
          _BottomSheetOption(LucideIcons.image, "Upload from Gallery", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            );
          }),
          _BottomSheetOption(LucideIcons.link, "Import from URL", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            );
          }),
        ],
      ),
    );
  }

  void _showCreateOutfitOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGlassBottomSheet(
        title: "Create Outfit",
        options: [
          _BottomSheetOption(LucideIcons.plusCircle, "Manual Builder", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OutfitBuilderScreen(),
              ),
            );
          }),
          _BottomSheetOption(LucideIcons.wand2, "AI Auto-Composer", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI Auto-Composer coming soon...")),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGlassBottomSheet({
    required String title,
    required List<_BottomSheetOption> options,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...options.map(
            (opt) => ListTile(
              leading: Icon(
                opt.icon,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                opt.label,
                style: GoogleFonts.outfit(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                opt.onTap();
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BottomSheetOption {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _BottomSheetOption(this.icon, this.label, this.onTap);
}
