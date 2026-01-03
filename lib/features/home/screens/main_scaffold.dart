import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/components/navigation/floating_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<NavItem> _navItems = const [
    NavItem(icon: LucideIcons.home, label: 'Home'),
    NavItem(icon: LucideIcons.shirt, label: 'Closet'),
    NavItem(icon: LucideIcons.palette, label: 'Outfits'),
    NavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: FixedBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onNavTap,
        items: _navItems,
        centerAction: _buildCenterAction(),
      ),
      floatingActionButton: widget.navigationShell.currentIndex == 1 ? _buildFloatingButton() : null, // Only show FAB on Closet page
    );
  }

  Widget _buildFloatingButton() {
    IconData icon;
    VoidCallback onPressed;

    switch (widget.navigationShell.currentIndex) {
      case 1: // Closet
        icon = LucideIcons.plus;
        onPressed = () => _showAddItemOptions();
        break;
      case 2: // Outfits
        icon = LucideIcons.plusCircle;
        onPressed = () => _showCreateOutfitOptions();
        break;
      case 3: // Profile - No FAB
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 6,
      child: Icon(icon, size: 28),
    );
  }

  Widget _buildCenterAction() {
    // Center stylist button for styling and outfit creation only
    return GestureDetector(
      onTap: () {
        // Always show styling options regardless of current page
        _showStylingOptions();
      },
      child: Container(
        padding: const EdgeInsets.all(12), // Adjusted padding for smaller navbar
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          FontAwesomeIcons.shirt,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 20, // Smaller icon to fit the reduced navbar height
        ),
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
            context.go('/closet/add/camera');
          }),
          _BottomSheetOption(LucideIcons.image, "Upload from Gallery", () {
            context.go('/closet/add/gallery');
          }),
          _BottomSheetOption(LucideIcons.link, "Import from URL", () {
            context.go('/closet/add/url');
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
            context.go('/outfits/create');
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

  void _showStylingOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGlassBottomSheet(
        title: "Style & Create",
        options: [
          _BottomSheetOption(LucideIcons.palette, "Create New Outfit", () {
            context.go('/outfits/create');
          }),
          _BottomSheetOption(LucideIcons.sparkles, "AI Style Assistant", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI Style Assistant coming soon...")),
            );
          }),
          _BottomSheetOption(LucideIcons.heart, "View My Outfits", () {
            context.go('/outfits');
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
