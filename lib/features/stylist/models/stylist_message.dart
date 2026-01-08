import 'style_proposal.dart';

enum MessageSender { user, assistant }

enum MessageType { text, image, styleProposal, loading, combined }

class StylistMessage {
  final String id;
  final MessageSender sender;
  final MessageType type;
  final String? text;
  final String? imageUrl;
  final StyleProposal? proposal;
  final DateTime timestamp;
  final dynamic attachment;

  StylistMessage({
    required this.id,
    required this.sender,
    required this.type,
    this.text,
    this.imageUrl,
    this.proposal,
    this.attachment,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory StylistMessage.userText(String text) {
    return StylistMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.user,
      type: MessageType.text,
      text: text,
    );
  }

  factory StylistMessage.assistantText(String text) {
    return StylistMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.assistant,
      type: MessageType.text,
      text: text,
    );
  }

  factory StylistMessage.userImage(String imageUrl) {
    return StylistMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.user,
      type: MessageType.image,
      imageUrl: imageUrl,
    );
  }

  factory StylistMessage.userCombined({required String text, required dynamic attachment}) {
    return StylistMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.user,
      type: MessageType.combined,
      text: text,
      attachment: attachment,
    );
  }

  factory StylistMessage.assistantProposal(StyleProposal proposal) {
    return StylistMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.assistant,
      type: MessageType.styleProposal,
      proposal: proposal,
    );
  }

  factory StylistMessage.loading() {
    return StylistMessage(
      id: 'loading',
      sender: MessageSender.assistant,
      type: MessageType.loading,
    );
  }
}
