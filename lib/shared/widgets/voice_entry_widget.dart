import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mess_manager/core/services/voice_entry_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/theme/app_theme.dart';

/// Voice Entry Button
///
/// A floating mic button that triggers voice entry.
/// Shows listening state with pulse animation.
class VoiceEntryButton extends ConsumerWidget {
  final void Function(VoiceCommand command)? onCommand;
  final double size;

  const VoiceEntryButton({super.key, this.onCommand, this.size = 56});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceEntryProvider);
    final notifier = ref.read(voiceEntryProvider.notifier);

    return GestureDetector(
      onTap: () async {
        if (state.isListening) {
          await notifier.stopListening();
          if (state.lastCommand?.isValid == true && onCommand != null) {
            onCommand!(state.lastCommand!);
          }
        } else {
          await notifier.startListening();
        }
      },
      onLongPress: () async {
        HapticService.longPressStart();
        await notifier.cancelListening();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: state.isListening ? AppColors.error : AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (state.isListening ? AppColors.error : AppColors.primary)
                  .withValues(alpha: 0.4),
              blurRadius: state.isListening ? 20 : 12,
              spreadRadius: state.isListening ? 2 : 0,
            ),
          ],
        ),
        child: state.isListening
            ? _buildListeningIcon()
            : Icon(LucideIcons.mic, color: Colors.white, size: size * 0.5),
      ),
    );
  }

  Widget _buildListeningIcon() {
    return Icon(LucideIcons.micOff, color: Colors.white, size: size * 0.5)
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.15, 1.15),
          duration: 600.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.15, 1.15),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.easeInOut,
        );
  }
}

/// Voice Entry Sheet
///
/// A bottom sheet for voice entry with visual feedback.
class VoiceEntrySheet extends ConsumerStatefulWidget {
  final void Function(VoiceCommand command)? onCommand;

  const VoiceEntrySheet({super.key, this.onCommand});

  @override
  ConsumerState<VoiceEntrySheet> createState() => _VoiceEntrySheetState();
}

class _VoiceEntrySheetState extends ConsumerState<VoiceEntrySheet> {
  @override
  void initState() {
    super.initState();
    // Start listening immediately when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceEntryProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    ref.read(voiceEntryProvider.notifier).cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceEntryProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Mic indicator
          _buildMicIndicator(state),
          const SizedBox(height: 24),

          // Recognized text
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                state.currentText.isEmpty
                    ? (state.isListening ? 'Listening...' : 'Tap mic to speak')
                    : state.currentText,
                style: TextStyle(
                  color: state.currentText.isEmpty
                      ? AppColors.textMutedDark
                      : AppColors.textPrimaryDark,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Parsed command preview
          if (state.lastCommand != null) ...[
            _buildCommandPreview(state.lastCommand!),
            const SizedBox(height: 16),
          ],

          // Example commands
          if (!state.isListening && state.currentText.isEmpty) _buildExamples(),

          // Error display
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.error!,
                style: TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.lastCommand?.isValid == true
                      ? () {
                          widget.onCommand?.call(state.lastCommand!);
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicIndicator(VoiceEntryState state) {
    return GestureDetector(
      onTap: () {
        final notifier = ref.read(voiceEntryProvider.notifier);
        if (state.isListening) {
          notifier.stopListening();
        } else {
          notifier.startListening();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: state.isListening ? AppColors.error : AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (state.isListening ? AppColors.error : AppColors.primary)
                  .withValues(alpha: 0.4),
              blurRadius: state.isListening ? 24 : 12,
              spreadRadius: state.isListening ? 4 : 0,
            ),
          ],
        ),
        child: Icon(
          state.isListening ? LucideIcons.micOff : LucideIcons.mic,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildCommandPreview(VoiceCommand command) {
    final isValid = command.isValid;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isValid ? AppColors.success : AppColors.warning).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isValid ? AppColors.success : AppColors.warning).withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? LucideIcons.check : LucideIcons.alertCircle,
            color: isValid ? AppColors.success : AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              command.toString(),
              style: TextStyle(
                color: isValid ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamples() {
    final examples = [
      '"Add 2 lunch for today"',
      '"3 dinner plus 1 guest"',
      '"Bazar 500 taka vegetables"',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try saying:',
          style: TextStyle(color: AppColors.textMutedDark, fontSize: 12),
        ),
        const SizedBox(height: 8),
        ...examples.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              e,
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Show voice entry sheet
Future<VoiceCommand?> showVoiceEntrySheet(BuildContext context) async {
  VoiceCommand? result;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        VoiceEntrySheet(onCommand: (command) => result = command),
  );

  return result;
}
