import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
      floatingActionButton: widget.navigationShell.currentIndex == 1
          ? _buildFloatingButton()
          : null, // Only show FAB on Closet page
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
    return GestureDetector(
      onTap: _showStylingOptions,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.plus,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 20,
        ),
      ),
    );
  }

  void _showAddItemOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMinimalBottomSheet(
        title: "Add Clothing",
        options: [
          _BottomSheetOption(LucideIcons.camera, "Take Photo", () {
            context.push('/closet/add/camera');
          }),
          _BottomSheetOption(LucideIcons.image, "Upload from Gallery", () {
            context.push('/closet/add/gallery');
          }),
          _BottomSheetOption(LucideIcons.link, "Import from URL", () {
            context.push('/closet/add/url');
          }),
        ],
      ),
    );
  }

  void _showCreateOutfitOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMinimalBottomSheet(
        title: "Create Outfit",
        options: [
          _BottomSheetOption(LucideIcons.plusCircle, "Manual Builder", () {
            context.push('/outfits/create');
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
      builder: (context) => _buildMinimalBottomSheet(
        title: "Style & Create",
        options: [
          _BottomSheetOption(LucideIcons.palette, "Create New Outfit", () {
            context.push('/outfits/create');
          }),
          _BottomSheetOption(LucideIcons.sparkles, "AI Style Assistant", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("AI Style Assistant coming soon..."),
              ),
            );
          }),
          _BottomSheetOption(LucideIcons.heart, "Add to Closet", () {
            _showAddItemOptions();
          }),
        ],
      ),
    );
  }

  Widget _buildMinimalBottomSheet({
    required String title,
    required List<_BottomSheetOption> options,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 24),
          ...options.map(
            (opt) => ListTile(
              leading: Icon(
                opt.icon,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              title: Text(
                opt.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
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
