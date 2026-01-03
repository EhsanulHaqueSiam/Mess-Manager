import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';

/// Voice Entry Widget
/// Simulates speech-to-text for adding entries
class VoiceEntrySheet extends StatefulWidget {
  final void Function(String spokenText, double? amount) onResult;

  const VoiceEntrySheet({super.key, required this.onResult});

  @override
  State<VoiceEntrySheet> createState() => _VoiceEntrySheetState();
}

class _VoiceEntrySheetState extends State<VoiceEntrySheet> {
  bool _isListening = false;
  String _spokenText = '';
  double? _detectedAmount;

  // Common phrases for demo
  final List<String> _examplePhrases = [
    'Rice 500 taka',
    'Add 2 meals for today',
    'Bazar 850 taka for vegetables',
    'Electricity bill 1200',
    'Oil and fish 600 taka',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(AppSpacing.lg),

          // Title
          Text(
            'Voice Entry',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Gap(AppSpacing.xs),
          Text(
            'Tap the mic and speak',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
          const Gap(AppSpacing.xl),

          // Microphone Button
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(_isListening ? 40 : 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isListening
                      ? [
                          AppColors.moneyNegative,
                          AppColors.moneyNegative.withValues(alpha: 0.7),
                        ]
                      : AppColors.gradientPrimary,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        (_isListening
                                ? AppColors.moneyNegative
                                : AppColors.primary)
                            .withValues(alpha: 0.4),
                    blurRadius: _isListening ? 30 : 20,
                    spreadRadius: _isListening ? 5 : 0,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? LucideIcons.micOff : LucideIcons.mic,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          const Gap(AppSpacing.md),

          // Status Text
          Text(
            _isListening ? 'Listening...' : 'Tap to speak',
            style: AppTypography.labelMedium.copyWith(
              color: _isListening
                  ? AppColors.moneyNegative
                  : AppColors.textMutedDark,
            ),
          ),
          const Gap(AppSpacing.xl),

          // Spoken Text Display
          if (_spokenText.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '"$_spokenText"',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_detectedAmount != null) ...[
                    const Gap(AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.moneyPositive.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Detected: ৳${_detectedAmount!.toStringAsFixed(0)}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.moneyPositive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            const Gap(AppSpacing.lg),

            // Use Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onResult(_spokenText, _detectedAmount);
                  Navigator.pop(context);
                },
                icon: const Icon(LucideIcons.check, size: 20),
                label: const Text('Use This'),
              ),
            ),
          ],

          // Example Phrases
          if (_spokenText.isEmpty) ...[
            const Gap(AppSpacing.md),
            Text(
              'Try saying...',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMutedDark,
              ),
            ),
            const Gap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              alignment: WrapAlignment.center,
              children: _examplePhrases.map((phrase) {
                return ActionChip(
                  label: Text(phrase),
                  onPressed: () => _simulateVoiceInput(phrase),
                  backgroundColor: AppColors.cardDark,
                  labelStyle: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                );
              }).toList(),
            ),
          ],
          const Gap(AppSpacing.lg),
        ],
      ),
    );
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        // Simulate listening for 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _isListening) {
            _simulateVoiceInput(
              _examplePhrases[DateTime.now().second % _examplePhrases.length],
            );
          }
        });
      }
    });
  }

  void _simulateVoiceInput(String text) {
    // Extract amount from text
    final amountMatch = RegExp(r'(\d+)').firstMatch(text);
    final amount = amountMatch != null
        ? double.tryParse(amountMatch.group(1)!)
        : null;

    setState(() {
      _isListening = false;
      _spokenText = text;
      _detectedAmount = amount;
    });
  }
}
