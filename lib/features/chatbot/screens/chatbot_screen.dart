import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/chatbot/providers/chatbot_provider.dart';

/// Chatbot Screen - Uses GetWidget + VelocityX + flutter_animate
class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(100.ms, () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage([String? text]) {
    final message = text ?? _textController.text;
    if (message.trim().isEmpty) return;

    HapticService.buttonPress();
    ref.read(chatbotProvider.notifier).sendMessage(message);
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatbotProvider);
    final chatNotifier = ref.read(chatbotProvider.notifier);

    ref.listen(chatbotProvider, (_, state) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: HStack([
          GFAvatar(
            backgroundColor: AppColors.primary,
            size: 36,
            child: const Icon(LucideIcons.bot, color: Colors.white, size: 20),
          ),
          8.widthBox,
          VStack(crossAlignment: CrossAxisAlignment.start, [
            'Area51 AI'.text.make(),
            'মেস সহকারী'.text.xs.color(AppColors.textMutedDark).make(),
          ]),
        ]),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.trash2, size: 20),
            type: GFButtonType.transparent,
            onPressed: () {
              HapticService.mediumTap();
              chatNotifier.clearChat();
            },
          ),
        ],
      ),
      body: VStack([
        // Messages
        Expanded(
          child: chatState.messages.isEmpty
              ? _buildEmptyState(chatNotifier)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount:
                      chatState.messages.length + (chatState.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chatState.messages.length &&
                        chatState.isLoading) {
                      return _buildTypingIndicator();
                    }
                    return _buildMessageBubble(chatState.messages[index]);
                  },
                ),
        ),

        // Suggestions
        if (chatState.messages.length < 3) _buildSuggestionChips(chatNotifier),

        // Input
        _buildInputField(),
      ]),
    );
  }

  Widget _buildEmptyState(ChatbotNotifier notifier) {
    return VStack(alignment: MainAxisAlignment.center, [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(LucideIcons.bot, color: Colors.white, size: 48),
      ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
      24.heightBox,
      'Area51 AI'.text.xl2.bold
          .color(AppColors.textPrimaryDark)
          .make()
          .animate()
          .fadeIn(delay: 200.ms),
      8.heightBox,
      'আপনার মেস সংক্রান্ত প্রশ্ন জিজ্ঞাসা করুন'.text
          .color(AppColors.textSecondaryDark)
          .center
          .make()
          .animate()
          .fadeIn(delay: 300.ms),
      16.heightBox,
      if (!ref.read(chatbotProvider).isReady)
        GFAppCard(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderColor: AppColors.warning.withValues(alpha: 0.3),
          child: HStack([
            const Icon(
              LucideIcons.alertTriangle,
              color: AppColors.warning,
              size: 16,
            ),
            8.widthBox,
            'API key not configured in Firebase Remote Config'.text.sm
                .color(AppColors.warning)
                .make()
                .flexible(),
          ]),
        ).px24().animate().fadeIn(delay: 400.ms),
    ]).centered();
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return HStack(
          alignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAlignment: CrossAxisAlignment.start,
          [
            if (!isUser) ...[
              GFAvatar(
                size: 28,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  LucideIcons.bot,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              8.widthBox,
            ],
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.cardDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: isUser
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.borderDark,
                ),
              ),
              child: message.text.text.color(AppColors.textPrimaryDark).make(),
            ),
            if (isUser) ...[
              8.widthBox,
              GFMemberAvatar(
                name: 'U',
                size: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              ),
            ],
          ],
        )
        .pOnly(bottom: AppSpacing.sm)
        .animate()
        .fadeIn(duration: 200.ms)
        .slideX(begin: isUser ? 0.1 : -0.1);
  }

  Widget _buildTypingIndicator() {
    return HStack([
      GFAvatar(
        size: 28,
        backgroundColor: AppColors.primary,
        child: const Icon(LucideIcons.bot, color: Colors.white, size: 14),
      ),
      8.widthBox,
      GFAppCard(
        child: HStack([
          _buildDot(0),
          4.widthBox,
          _buildDot(1),
          4.widthBox,
          _buildDot(2),
        ]),
      ),
    ]).pOnly(bottom: AppSpacing.sm);
  }

  Widget _buildDot(int index) {
    return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.textMutedDark,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .fadeIn(delay: (index * 200).ms, duration: 400.ms)
        .fadeOut(delay: (index * 200 + 400).ms, duration: 400.ms);
  }

  Widget _buildSuggestionChips(ChatbotNotifier notifier) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: notifier.suggestions.map((suggestion) {
        return GFButton(
          onPressed: () => _sendMessage(suggestion),
          text: suggestion,
          size: GFSize.SMALL,
          type: GFButtonType.outline,
          color: AppColors.primary,
          textColor: AppColors.primary,
        );
      }).toList(),
    ).p12().animate().fadeIn(delay: 500.ms);
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(top: BorderSide(color: AppColors.borderDark)),
      ),
      child: HStack([
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'জিজ্ঞাসা করুন...',
            filled: true,
            fillColor: AppColors.cardDark,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) => _sendMessage(),
        ).expand(),
        8.widthBox,
        GFIconButton(
          icon: const Icon(LucideIcons.send, color: Colors.white, size: 20),
          type: GFButtonType.solid,
          color: AppColors.primary,
          shape: GFIconButtonShape.circle,
          onPressed: _sendMessage,
        ),
      ]),
    );
  }
}
