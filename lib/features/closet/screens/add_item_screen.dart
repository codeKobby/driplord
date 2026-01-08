import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/services/ai_image_service.dart';
import '../screens/segmented_items_review_screen.dart';

enum AddItemPhase {
  selection,    // Choose camera/gallery/URL
  processing,   // AI analyzing image
  review,       // User reviewing detected items
}

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key, this.initialUrl, this.imagePath, this.source});

  final String? initialUrl;
  final String? imagePath;
  final String? source;

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _urlController = TextEditingController();

  AddItemPhase _currentPhase = AddItemPhase.selection;
  XFile? _selectedImage;
  String? _imageUrl;
  String? _processingError;

  @override
  void initState() {
    super.initState();
    // Handle different input sources
    if (widget.initialUrl != null) {
      // URL input - process immediately
      _urlController.text = widget.initialUrl!;
      _processUrlInput();
    } else if (widget.imagePath != null) {
      // Image file from camera/gallery - process immediately
      _selectedImage = XFile(widget.imagePath!);
      _currentPhase = AddItemPhase.processing;
      _processImage();
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                LucideIcons.x,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => _resetToSelection(),
            ),
            title: Text(
              _getTitleForPhase(),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentPhase(),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleForPhase() {
    switch (_currentPhase) {
      case AddItemPhase.selection:
        return "Add New Item";
      case AddItemPhase.processing:
        return "Processing Image";
      case AddItemPhase.review:
        return "Review Items";
    }
  }

  Widget _buildCurrentPhase() {
    switch (_currentPhase) {
      case AddItemPhase.selection:
        return _buildSelectionPhase();
      case AddItemPhase.processing:
        return _buildProcessingPhase();
      case AddItemPhase.review:
        return _buildReviewPhase();
    }
  }

  Widget _buildSelectionPhase() {
    return Column(
      children: [
        _buildUploadSection(context),
        const SizedBox(height: 32),
        _buildOptionCard(
          context,
          icon: LucideIcons.camera,
          title: "Take a Photo",
          subtitle: "Use your camera to capture an item",
          onTap: _takePhoto,
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context,
          icon: LucideIcons.image,
          title: "Choose from Gallery",
          subtitle: "Select a photo from your library",
          onTap: _chooseFromGallery,
        ),
        const SizedBox(height: 16),
        _buildUrlInputCard(context),
        const Spacer(),
        Text(
          "AI will automatically detect and categorize clothing items from your photos.",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingPhase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const CircularProgressIndicator(),
        ),
        const SizedBox(height: 32),
        Text(
          "Analyzing your image...",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "AI is detecting clothing items and extracting details",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        if (_processingError != null) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(LucideIcons.alertCircle, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 8),
                Text(
                  _processingError!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: "Try Again",
            onPressed: _resetToSelection,
            icon: LucideIcons.rotateCcw,
          ),
        ],
      ],
    );
  }

  Widget _buildReviewPhase() {
    // This phase will navigate to the SegmentedItemsReviewScreen
    // For now, show a placeholder
    return const Center(
      child: Text("Review phase - will navigate to review screen"),
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.upload,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Upload Clothing Photo",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Supports JPG, PNG, WEBP",
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ],
      ),
    );
  }

  void _resetToSelection() {
    setState(() {
      _currentPhase = AddItemPhase.selection;
      _selectedImage = null;
      _imageUrl = null;
      _processingError = null;
      _urlController.clear();
    });
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _currentPhase = AddItemPhase.processing;
        });
        await _processImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _chooseFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _currentPhase = AddItemPhase.processing;
        });
        await _processImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _processUrlInput() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    // Basic URL validation
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL starting with http:// or https://')),
      );
      return;
    }

    setState(() {
      _imageUrl = url;
      _currentPhase = AddItemPhase.processing;
    });

    await _processImage();
  }

  Future<void> _processImage() async {
    try {
      setState(() {
        _processingError = null;
      });

      // TODO: Initialize AI service with API key from secure storage
      // For now, we'll simulate processing
      await Future.delayed(const Duration(seconds: 2));

      // Mock AI processing result
      final mockItems = [
        DetectedClothingItem(
          id: '1',
          name: 'Blue Cotton T-Shirt',
          category: 'tops',
          color: 'blue',
          confidence: 0.95,
        ),
        DetectedClothingItem(
          id: '2',
          name: 'Black Jeans',
          category: 'bottoms',
          color: 'black',
          confidence: 0.88,
        ),
      ];

      // Navigate to review screen
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SegmentedItemsReviewScreen(
              imageUrl: _imageUrl ?? 'mock_image_url', // TODO: Get actual image URL
              detectedItems: mockItems,
              source: _selectedImage != null ? 'camera' : 'url',
            ),
          ),
        ).then((_) {
          // When returning from review screen, reset to selection
          _resetToSelection();
        });
      }

    } catch (e) {
      setState(() {
        _processingError = e.toString();
      });
    }
  }

  Widget _buildUrlInputCard(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.link,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "Paste image URL from online store",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.outfit(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  style: GoogleFonts.outfit(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: "Process URL",
            onPressed: _processUrlInput,
            icon: LucideIcons.link,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
