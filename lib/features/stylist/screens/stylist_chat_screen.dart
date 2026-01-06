import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/stylist_assistant_provider.dart';
import '../models/stylist_message.dart';
import '../models/style_proposal.dart';
import '../../closet/providers/closet_provider.dart';
import '../../home/providers/saved_outfits_provider.dart';

class StylistChatScreen extends ConsumerStatefulWidget {
  const StylistChatScreen({super.key});

  @override
  ConsumerState<StylistChatScreen> createState() => _StylistChatScreenState();
}

class _StylistChatScreenState extends ConsumerState<StylistChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(stylistAssistantProvider.notifier).sendImage(image.path);
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentMenu(),
    );
  }

  Widget _buildAttachmentMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Share Inspiration",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(
                icon: LucideIcons.image,
                label: "Library",
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              _buildAttachmentOption(
                icon: LucideIcons.shirt,
                label: "My Closet",
                onTap: () {
                  Navigator.pop(context);
                  _showClosetPicker();
                },
              ),
              _buildAttachmentOption(
                icon: LucideIcons.palette,
                label: "My Outfits",
                onTap: () {
                  Navigator.pop(context);
                  _showOutfitPicker();
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClosetPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final closet = ref.watch(closetProvider);
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "Select from Closet",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: closet.length,
                          itemBuilder: (context, index) {
                            final item = closet[index];
                            return InkWell(
                              onTap: () {
                                ref
                                    .read(stylistAssistantProvider.notifier)
                                    .sendClosetItem(item.imageUrl, item.name);
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          image: NetworkImage(item.imageUrl),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showOutfitPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final outfits = ref.watch(savedOutfitsProvider);
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "Select an Outfit",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: outfits.length,
                          itemBuilder: (context, index) {
                            final outfit = outfits[index];
                            return InkWell(
                              onTap: () {
                                ref
                                    .read(stylistAssistantProvider.notifier)
                                    .sendOutfit(
                                      outfit.personalImageUrl,
                                      outfit.title,
                                    );
                                Navigator.pop(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            outfit.personalImageUrl,
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    outfit.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stylistAssistantProvider);

    // Auto-scroll when new messages arrive
    ref.listen(stylistAssistantProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: state.messages.length + (state.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.messages.length && state.isTyping) {
                  return _buildLoadingIndicator();
                }
                final message = state.messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(LucideIcons.chevronLeft, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Column(
        children: [
          Text(
            "Stylist Agent",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "Online",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.moreVertical, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessage(StylistMessage message) {
    bool isUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.type == MessageType.text)
            _buildTextBubble(message.text!, isUser),
          if (message.type == MessageType.image)
            _buildImageBubble(message.imageUrl!, isUser),
          if (message.type == MessageType.styleProposal)
            _buildProposalCard(message.proposal!),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: isUser ? 0.2 : -0.2),
    );
  }

  Widget _buildTextBubble(String text, bool isUser) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? AppColors.pureBlack : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        border: isUser ? null : Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: isUser ? AppColors.pureWhite : AppColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageBubble(String path, bool isUser) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(path), // In mock, we assume URLs for now
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProposalCard(StyleProposal proposal) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.sparkles,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "NEW LOOK PROPOSAL",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  proposal.title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  proposal.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: proposal.items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = proposal.items[index];
                return Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(item.imageUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/try-on', extra: proposal.items);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pureBlack,
                      foregroundColor: AppColors.pureWhite,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Edit in Canvas",
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Icon(
                    LucideIcons.heart,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _showAttachmentMenu,
            icon: Icon(
              LucideIcons.plus,
              color: AppColors.textPrimary,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.glassBorder.withValues(alpha: 0.5),
                ),
              ),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Ask your stylist...",
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    ref
                        .read(stylistAssistantProvider.notifier)
                        .sendMessage(val);
                    _controller.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 52,
            width: 52,
            decoration: const BoxDecoration(
              color: AppColors.pureBlack,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                LucideIcons.send,
                size: 20,
                color: AppColors.pureWhite,
              ),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  ref
                      .read(stylistAssistantProvider.notifier)
                      .sendMessage(_controller.text);
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
