import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/components/navigation/floating_nav_bar.dart';
import '../../closet/providers/closet_provider.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  final List<NavItem> _navItems = const [
    NavItem(icon: LucideIcons.home, label: 'Home'),
    NavItem(icon: LucideIcons.shirt, label: 'Closet'),
    NavItem(icon: LucideIcons.palette, label: 'Outfits'),
    NavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    // If switching TO or FROM the closet tab (index 1), clear its volatile state
    // This satisfies the "clear state after page switching" requirement
    if (widget.navigationShell.currentIndex == 1 || index == 1) {
      ref.invalidate(searchQueryProvider);
      ref.invalidate(filterOptionsProvider);
      ref.invalidate(selectedCategoryProvider);
    }

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
      floatingActionButton: (widget.navigationShell.currentIndex == 1 || widget.navigationShell.currentIndex == 2)
          ? _buildFloatingButton()
          : null, // Show FAB on Closet and Outfits pages
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
          LucideIcons.sparkles,
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
            _takePhoto();
          }),
          _BottomSheetOption(LucideIcons.image, "Upload from Gallery", () {
            _pickFromGallery();
          }),
          _BottomSheetOption(LucideIcons.link, "Import from URL", () {
            _showUrlInputModal(context);
          }),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear, // Use rear camera
      );
      if (image != null && mounted) {
        // Navigate to processing screen with the image
        context.push('/closet/add/camera/${Uri.encodeComponent(image.path)}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        // Navigate to processing screen with the image
        context.push('/closet/add/gallery/${Uri.encodeComponent(image.path)}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showUrlInputModal(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Import from URL",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: "Paste image URL from online store",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(LucideIcons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final url = urlController.text.trim();
                      if (url.isNotEmpty) {
                        Navigator.pop(context);
                        // Navigate to processing screen with URL
                        context.push('/closet/add/url/${Uri.encodeComponent(url)}');
                      }
                    },
                    child: const Text("Process URL"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
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
          _BottomSheetOption(LucideIcons.sparkles, "AI Style Assistant", () {
            context.push('/stylist');
          }),
          _BottomSheetOption(LucideIcons.palette, "Create New Outfit", () {
            context.push('/outfits/create');
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
