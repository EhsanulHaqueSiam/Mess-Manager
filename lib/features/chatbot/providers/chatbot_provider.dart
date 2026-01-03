import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/services/chatbot_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';

/// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

/// Chat state
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isReady;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isReady = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isReady,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isReady: isReady ?? this.isReady,
    );
  }
}

/// Chat provider
final chatbotProvider = NotifierProvider<ChatbotNotifier, ChatState>(
  ChatbotNotifier.new,
);

class ChatbotNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    _initChat();
    return const ChatState();
  }

  Future<void> _initChat() async {
    final chatService = ChatbotService.instance;
    await chatService.init();

    if (!chatService.isReady) {
      state = state.copyWith(isReady: false);
      return;
    }

    // Get context data using existing providers
    final currentMember = ref.read(currentMemberProvider);
    final members = ref.read(membersProvider);
    final currentBalance = ref.read(currentMemberBalanceProvider);
    final mealRate = ref.read(mealRateProvider);
    final bazarByMember = ref.read(bazarByMemberProvider);

    if (currentMember != null) {
      final balance = currentBalance?.balance ?? 0.0;
      final mealCount = (currentBalance?.totalMeals ?? 0.0).toInt();
      final bazarTotal = bazarByMember[currentMember.id] ?? 0.0;

      chatService.startChat(
        currentMember: currentMember,
        balance: balance,
        mealCount: mealCount,
        mealRate: mealRate,
        bazarTotal: bazarTotal,
        memberCount: members.length,
      );
    }

    state = state.copyWith(isReady: chatService.isReady);
  }

  /// Send a message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    // Get AI response
    final response = await ChatbotService.instance.sendMessage(text);

    // Add AI message
    final aiMessage = ChatMessage(text: response, isUser: false);
    state = state.copyWith(
      messages: [...state.messages, aiMessage],
      isLoading: false,
    );
  }

  /// Get suggestions
  List<String> get suggestions => ChatbotService.instance.suggestions;

  /// Clear chat
  void clearChat() {
    state = state.copyWith(messages: []);
    _initChat(); // Reinitialize chat session
  }
}
