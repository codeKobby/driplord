import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/components/navigation/floating_nav_bar.dart';
import '../../../core/components/common/driplord_scaffold.dart';

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
    NavItem(icon: LucideIcons.bookmark, label: 'Outfits'),
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
    return DripLordScaffold(
      useSafeArea: false,
      body: Stack(
        children: [
          // The main content body
          widget.navigationShell,

          // Floating buttons for pages other than home
          if (widget.navigationShell.currentIndex != 0) _buildFloatingButton(),

          // Navigation Bar
          FloatingNavBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _onNavTap,
            items: _navItems,
            centerAction: _buildCenterAction(),
          ),
        ],
      ),
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
      case 3: // Profile
        icon = LucideIcons.user;
        onPressed = () {}; // Profile actions
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned(
      right: 32,
      bottom: 120, // Position above the nav bar
      child:
          GestureDetector(
                onTap: onPressed,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
              )
              .animate(key: ValueKey(widget.navigationShell.currentIndex))
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
              .fadeIn(),
    );
  }

  Widget? _buildCenterAction() {
    // Always show stylist button inline in nav bar for all pages
    return GestureDetector(
      onTap: () {
        switch (widget.navigationShell.currentIndex) {
          case 0:
            _showGenerateOptions();
            break;
          case 1:
            _showAddItemOptions();
            break;
          case 2:
            _showCreateOutfitOptions();
            break;
          case 3:
            // Profile actions
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.navigationShell.currentIndex == 0
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: widget.navigationShell.currentIndex == 0
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ]
              : [],
        ),
        child: Icon(
          FontAwesomeIcons.shirt,
          color: widget.navigationShell.currentIndex == 0
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          size: 24,
        ),
      ),
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
