import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stylist_message.dart';
import '../models/style_proposal.dart';
import '../../try_on/models/outfit_item.dart';
import '../../closet/providers/closet_provider.dart';

class StylistAssistantState {
  final List<StylistMessage> messages;
  final bool isTyping;

  StylistAssistantState({this.messages = const [], this.isTyping = false});

  StylistAssistantState copyWith({
    List<StylistMessage>? messages,
    bool? isTyping,
  }) {
    return StylistAssistantState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class StylistAssistantNotifier extends Notifier<StylistAssistantState> {
  @override
  StylistAssistantState build() {
    return StylistAssistantState(
      messages: [
        StylistMessage.assistantText(
          "Hey! I'm your AI Style Assistant. I can help you find items in your closet or put together fresh looks. What are we vibing with today?",
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    final userMessage = StylistMessage.userText(text);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    // Provide a small delay to simulate thinking
    await Future.delayed(const Duration(seconds: 1));

    _processInput(text);
  }

  Future<void> sendImage(String path) async {
    final userMessage = StylistMessage.userImage(path);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    await Future.delayed(const Duration(seconds: 1));

    // For images, we just mock a generic response for now
    state = state.copyWith(
      messages: [
        ...state.messages,
        StylistMessage.assistantText(
          "Nice reference! Give me a second to find something similar in your closet...",
        ),
      ],
    );

    await Future.delayed(const Duration(seconds: 1));
    _processInput("find something similar to this image");
  }

  Future<void> sendClosetItem(String imageUrl, String name) async {
    final userMessage = StylistMessage.userText(
      "Check this out from my closet: $name",
    );
    final imageMessage = StylistMessage.userImage(imageUrl);
    state = state.copyWith(
      messages: [...state.messages, userMessage, imageMessage],
      isTyping: true,
    );

    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isTyping: false,
      messages: [
        ...state.messages,
        StylistMessage.assistantText(
          "I see! $name is a great piece. How would you like me to style it?",
        ),
      ],
    );
  }

  Future<void> sendOutfit(String imageUrl, String title) async {
    final userMessage = StylistMessage.userText(
      "What do you think of my outfit: $title",
    );
    final imageMessage = StylistMessage.userImage(imageUrl);
    state = state.copyWith(
      messages: [...state.messages, userMessage, imageMessage],
      isTyping: true,
    );

    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isTyping: false,
      messages: [
        ...state.messages,
        StylistMessage.assistantText(
          "I love the $title vibe! Are you looking to tweak this one or create something completely different?",
        ),
      ],
    );
  }

  void _processInput(String input) {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains("outfit") ||
        lowerInput.contains("recommend") ||
        lowerInput.contains("vibe")) {
      _mockOutfitRecommendation(lowerInput);
    } else if (lowerInput.contains("find") ||
        lowerInput.contains("show me") ||
        lowerInput.contains("search")) {
      _mockClosetSearch(lowerInput);
    } else {
      state = state.copyWith(
        isTyping: false,
        messages: [
          ...state.messages,
          StylistMessage.assistantText(
            "I'm not quite sure how to help with that yet, but I can find items in your closet or recommend outfits if you'd like!",
          ),
        ],
      );
    }
  }

  void _mockClosetSearch(String query) {
    final closet = ref.read(closetProvider);
    // Simple mock search logic
    final foundItems = closet.where((item) {
      return query.contains(item.category.toLowerCase()) ||
          query.contains(item.name.toLowerCase()) ||
          query.contains(item.color?.toLowerCase() ?? "");
    }).toList();

    if (foundItems.isNotEmpty) {
      final itemNames = foundItems.map((e) => e.name).take(3).join(", ");
      state = state.copyWith(
        isTyping: false,
        messages: [
          ...state.messages,
          StylistMessage.assistantText(
            "I found these in your closet: $itemNames. Which one should we style?",
          ),
        ],
      );
    } else {
      state = state.copyWith(
        isTyping: false,
        messages: [
          ...state.messages,
          StylistMessage.assistantText(
            "I couldn't find anything matching that in your closet. Try something else?",
          ),
        ],
      );
    }
  }

  void _mockOutfitRecommendation(String query) {
    final closet = ref.read(closetProvider);

    // Try to pick one from each main category
    final tops = closet
        .where((e) => e.category.toLowerCase().contains("top"))
        .toList();
    final bottoms = closet
        .where((e) => e.category.toLowerCase().contains("bottom"))
        .toList();
    final shoes = closet
        .where(
          (e) =>
              e.category.toLowerCase().contains("shoe") ||
              e.category.toLowerCase().contains("footwear"),
        )
        .toList();

    if (tops.isEmpty || bottoms.isEmpty) {
      state = state.copyWith(
        isTyping: false,
        messages: [
          ...state.messages,
          StylistMessage.assistantText(
            "Your closet is a bit empty for a full recommendation! Add more items first.",
          ),
        ],
      );
      return;
    }

    final selectedTop = tops[0];
    final selectedBottom = bottoms[0];
    final selectedShoes = shoes.isNotEmpty ? shoes[0] : null;

    final proposalItems = [
      OutfitStackItem(
        id: selectedTop.id,
        category: selectedTop.category,
        name: selectedTop.name,
        imageUrl: selectedTop.imageUrl,
      ),
      OutfitStackItem(
        id: selectedBottom.id,
        category: selectedBottom.category,
        name: selectedBottom.name,
        imageUrl: selectedBottom.imageUrl,
      ),
    ];
    if (selectedShoes != null) {
      proposalItems.add(
        OutfitStackItem(
          id: selectedShoes.id,
          category: selectedShoes.category,
          name: selectedShoes.name,
          imageUrl: selectedShoes.imageUrl,
        ),
      );
    }

    final proposal = StyleProposal(
      id: "prop_${DateTime.now().millisecondsSinceEpoch}",
      title: "The Weekend Minimalist",
      description:
          "Based on your request, I've put together this clean, effortless look from your closet.",
      items: proposalItems,
    );

    state = state.copyWith(
      isTyping: false,
      messages: [...state.messages, StylistMessage.assistantProposal(proposal)],
    );
  }
}

final stylistAssistantProvider =
    NotifierProvider<StylistAssistantNotifier, StylistAssistantState>(() {
      return StylistAssistantNotifier();
    });
