import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/gf_components.dart';
import 'package:mess_manager/features/duties/providers/duty_provider.dart';

/// Duties Screen - Uses GetWidget + VelocityX + flutter_animate
class DutiesScreen extends ConsumerStatefulWidget {
  const DutiesScreen({super.key});

  @override
  ConsumerState<DutiesScreen> createState() => _DutiesScreenState();
}

class _DutiesScreenState extends ConsumerState<DutiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayDuties = ref.watch(todayDutiesProvider);
    final weeklyStats = ref.watch(weeklyDutyStatsProvider);
    final members = ref.watch(membersProvider);
    final schedules = ref.watch(dutySchedulesProvider);
    final dutyDebts = ref.watch(dutyDebtsProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    // Calculate debts/credits for current user
    final myDebts = dutyDebts
        .where((d) => d.debtorId == currentMemberId && !d.isSettled)
        .toList();
    final myCredits = dutyDebts
        .where((d) => d.creditorId == currentMemberId && !d.isSettled)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: HStack([
          const Icon(
            LucideIcons.clipboardList,
            color: AppColors.primary,
            size: 22,
          ),
          8.widthBox,
          'Duties'.text.make(),
        ]),
        actions: [
          GFIconButton(
            icon: const Icon(LucideIcons.plus, size: 20),
            type: GFButtonType.transparent,
            onPressed: () => _showAddScheduleSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: VStack(crossAlignment: CrossAxisAlignment.start, [
          // Stats Card
          _buildStatsCard(weeklyStats),
          16.heightBox,

          // Today's Duties
          _sectionHeader("Today's Duties"),
          8.heightBox,
          if (todayDuties.isEmpty)
            _buildEmptyState('No duties scheduled for today')
          else
            ...todayDuties.asMap().entries.map((entry) {
              final duty = entry.value;
              String memberName = 'Unknown';
              for (final m in members) {
                if (m.id == duty.memberId) {
                  memberName = m.name;
                  break;
                }
              }
              return _buildDutyCard(duty, memberName, entry.key);
            }),
          16.heightBox,

          // Duty Debts Section (who owes whom)
          if (myDebts.isNotEmpty || myCredits.isNotEmpty) ...[
            _sectionHeader('Duty Balance'),
            8.heightBox,
            _buildDutyDebtsCard(myDebts, myCredits, members),
            16.heightBox,
          ],

          // Rotation Schedules
          _sectionHeader('Rotation Schedules'),
          8.heightBox,
          if (schedules.isEmpty)
            _buildQuickSetupCard(members)
          else
            ...schedules.asMap().entries.map(
              (entry) => _buildScheduleCard(entry.value, members, entry.key),
            ),
          80.heightBox,
        ]),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return HStack([
      Container(
        width: 4,
        height: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientPrimary,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      8.widthBox,
      title.text.xl.bold.color(AppColors.textPrimaryDark).make(),
    ]);
  }

  Widget _buildStatsCard(Map<String, int> stats) {
    final total = stats['total'] ?? 0;
    final completed = stats['completed'] ?? 0;
    final progress = total > 0 ? completed / total : 0.0;

    return GFCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.8),
          AppColors.primaryLight.withValues(alpha: 0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: VStack([
        HStack([
          VStack(crossAlignment: CrossAxisAlignment.start, [
            'This Week'.text.sm
                .color(Colors.white.withValues(alpha: 0.8))
                .make(),
            4.heightBox,
            '$completed / $total Completed'.text.xl.white.bold.make(),
          ]).expand(),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              LucideIcons.checkSquare,
              color: Colors.white,
              size: 28,
            ),
          ),
        ]),
        12.heightBox,
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            minHeight: 8,
          ),
        ),
        12.heightBox,
        HStack(alignment: MainAxisAlignment.spaceAround, [
          _statItem('Pending', '${stats['pending'] ?? 0}'),
          _statItem('Completed', '$completed'),
          _statItem('Skipped', '${stats['skipped'] ?? 0}'),
        ]),
      ]),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _statItem(String label, String value) {
    return VStack([
      value.text.lg.white.bold.make(),
      label.text.xs.color(Colors.white.withValues(alpha: 0.7)).make(),
    ]);
  }

  Widget _buildEmptyState(String message) {
    return GFAppCard(
      child: message.text.color(AppColors.textMutedDark).center.make().p16(),
    );
  }

  Widget _buildDutyDebtsCard(
    List<DutyDebt> debts,
    List<DutyDebt> credits,
    List members,
  ) {
    String getMemberName(String id) {
      for (final m in members) {
        if (m.id == id) return m.name;
      }
      return 'Unknown';
    }

    return GFAppCard(
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        // Credits (duties others owe you)
        if (credits.isNotEmpty) ...[
          HStack([
            const Icon(
              LucideIcons.trendingUp,
              color: AppColors.moneyPositive,
              size: 18,
            ),
            8.widthBox,
            'Others Owe You'.text.bold.color(AppColors.moneyPositive).make(),
          ]),
          8.heightBox,
          ...credits.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: HStack([
                GFAvatar(
                  size: 28,
                  backgroundColor: AppColors.moneyPositive.withValues(
                    alpha: 0.1,
                  ),
                  child: getMemberName(
                    c.debtorId,
                  )[0].text.sm.color(AppColors.moneyPositive).make(),
                ),
                8.widthBox,
                '${getMemberName(c.debtorId)} owes you 1 ${_getDutyName(c.dutyType)}'
                    .text
                    .sm
                    .color(AppColors.textSecondaryDark)
                    .make()
                    .expand(),
              ]),
            ),
          ),
          if (debts.isNotEmpty) 12.heightBox,
        ],

        // Debts (duties you owe others)
        if (debts.isNotEmpty) ...[
          HStack([
            const Icon(
              LucideIcons.trendingDown,
              color: AppColors.moneyNegative,
              size: 18,
            ),
            8.widthBox,
            'You Owe'.text.bold.color(AppColors.moneyNegative).make(),
          ]),
          8.heightBox,
          ...debts.map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: HStack([
                GFAvatar(
                  size: 28,
                  backgroundColor: AppColors.moneyNegative.withValues(
                    alpha: 0.1,
                  ),
                  child: getMemberName(
                    d.creditorId,
                  )[0].text.sm.color(AppColors.moneyNegative).make(),
                ),
                8.widthBox,
                'You owe ${getMemberName(d.creditorId)} 1 ${_getDutyName(d.dutyType)}'
                    .text
                    .sm
                    .color(AppColors.textSecondaryDark)
                    .make()
                    .expand(),
              ]),
            ),
          ),
        ],
      ]).p12(),
    ).animate().fadeIn().slideX(begin: -0.05);
  }

  Widget _buildQuickSetupCard(List members) {
    return GFAppCard(
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: VStack([
        const Icon(LucideIcons.settings2, color: AppColors.primary, size: 40),
        12.heightBox,
        'No Schedules Set Up'.text.lg
            .color(AppColors.textPrimaryDark)
            .center
            .make(),
        4.heightBox,
        'Create rotation schedules to auto-assign duties'.text.sm
            .color(AppColors.textMutedDark)
            .center
            .make(),
        16.heightBox,
        HStack([
          GFPrimaryButton(
            text: 'Quick Setup',
            icon: LucideIcons.zap,
            onPressed: () => _quickSetup(members),
          ).expand(),
          8.widthBox,
          GFSecondaryButton(
            text: 'Custom',
            onPressed: () => _showAddScheduleSheet(context),
          ).expand(),
        ]),
      ]).p16(),
    ).animate().fadeIn();
  }

  Widget _buildDutyCard(DutyAssignment duty, String memberName, int index) {
    final currentMemberId = ref.watch(currentMemberIdProvider);
    final isMyDuty = duty.memberId == currentMemberId;
    final color = _getDutyColor(duty.type);
    final (statusColor, statusIcon, statusText) = _getStatusInfo(
      duty.status,
      color,
    );

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      borderColor: statusColor.withValues(alpha: 0.3),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        HStack([
          GFAvatar(
            size: 40,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(_getDutyIcon(duty.type), color: color, size: 22),
          ),
          12.widthBox,
          VStack(crossAlignment: CrossAxisAlignment.start, [
            _getDutyName(
              duty.type,
            ).text.bold.color(AppColors.textPrimaryDark).make(),
            2.heightBox,
            HStack([
              const Icon(
                LucideIcons.user,
                size: 12,
                color: AppColors.textMutedDark,
              ),
              4.widthBox,
              memberName.text.sm.color(AppColors.textSecondaryDark).make(),
            ]),
          ]).expand(),
          // Status Badge
          GFBadge(
            text: statusText,
            color: statusColor.withValues(alpha: 0.1),
            textColor: statusColor,
            size: GFSize.SMALL,
            shape: GFBadgeShape.pills,
          ),
        ]),

        // Action buttons
        if (duty.status == DutyStatus.pending && isMyDuty) ...[
          8.heightBox,
          HStack(alignment: MainAxisAlignment.end, [
            GFButton(
              onPressed: () => _showCompleteSheet(duty),
              text: 'Complete with Photo',
              icon: const Icon(
                LucideIcons.camera,
                size: 16,
                color: Colors.white,
              ),
              color: AppColors.moneyPositive,
              size: GFSize.SMALL,
            ),
          ]),
        ],

        // Dispute button (for non-owners on completed duties)
        if (duty.status == DutyStatus.completed && !isMyDuty) ...[
          8.heightBox,
          HStack(alignment: MainAxisAlignment.end, [
            GFButton(
              onPressed: () => _showDisputeSheet(duty),
              text: 'Dispute',
              icon: const Icon(
                LucideIcons.alertTriangle,
                size: 16,
                color: AppColors.warning,
              ),
              color: AppColors.warning.withValues(alpha: 0.2),
              textColor: AppColors.warning,
              type: GFButtonType.outline,
              size: GFSize.SMALL,
            ),
          ]),
        ],

        // Admin actions
        if ((duty.status == DutyStatus.disputed ||
                duty.status == DutyStatus.completed) &&
            _isAdmin()) ...[
          8.heightBox,
          HStack(alignment: MainAxisAlignment.end, [
            GFButton(
              onPressed: () => _rejectDuty(duty),
              text: 'Reject',
              icon: const Icon(LucideIcons.x, size: 16, color: AppColors.error),
              type: GFButtonType.outline,
              color: AppColors.error,
              textColor: AppColors.error,
              size: GFSize.SMALL,
            ),
            8.widthBox,
            GFButton(
              onPressed: () => _approveDuty(duty),
              text: 'Approve',
              icon: const Icon(
                LucideIcons.check,
                size: 16,
                color: Colors.white,
              ),
              color: AppColors.moneyPositive,
              size: GFSize.SMALL,
            ),
          ]),
        ],
      ]),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  (Color, IconData, String) _getStatusInfo(
    DutyStatus status,
    Color defaultColor,
  ) {
    return switch (status) {
      DutyStatus.pending => (defaultColor, LucideIcons.clock, 'Pending'),
      DutyStatus.completed => (
        AppColors.info,
        LucideIcons.checkCircle,
        'Awaiting Approval',
      ),
      DutyStatus.disputed => (
        AppColors.warning,
        LucideIcons.alertTriangle,
        'Disputed',
      ),
      DutyStatus.approved => (
        AppColors.moneyPositive,
        LucideIcons.checkCircle2,
        'Approved',
      ),
      DutyStatus.rejected => (AppColors.error, LucideIcons.xCircle, 'Rejected'),
      DutyStatus.skipped => (
        AppColors.textMutedDark,
        LucideIcons.skipForward,
        'Skipped',
      ),
      DutyStatus.swapped => (AppColors.accent, LucideIcons.repeat, 'Swapped'),
    };
  }

  Widget _buildScheduleCard(DutySchedule schedule, List members, int index) {
    final color = _getDutyColor(schedule.type);

    return GFAppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: HStack([
        GFAvatar(
          size: 36,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(_getDutyIcon(schedule.type), color: color, size: 20),
        ),
        12.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          _getDutyName(
            schedule.type,
          ).text.bold.color(AppColors.textPrimaryDark).make(),
          2.heightBox,
          '${schedule.rotationOrder.length} members • ${schedule.rotationIntervalDays}d rotation'
              .text
              .sm
              .color(AppColors.textMutedDark)
              .make(),
        ]).expand(),
        GFBadge(
          text: schedule.isActive ? 'Active' : 'Paused',
          color: schedule.isActive
              ? AppColors.moneyPositive.withValues(alpha: 0.1)
              : AppColors.textMutedDark.withValues(alpha: 0.1),
          textColor: schedule.isActive
              ? AppColors.moneyPositive
              : AppColors.textMutedDark,
          size: GFSize.SMALL,
          shape: GFBadgeShape.pills,
        ),
      ]),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  Color _getDutyColor(DutyType type) => switch (type) {
    DutyType.roomCleaning => AppColors.primary,
    DutyType.diningCleanup => AppColors.accentWarm,
    DutyType.bazarDuty => AppColors.bazarColor,
    DutyType.garbageDisposal => AppColors.moneyNegative,
    DutyType.cooking => AppColors.secondary,
  };

  IconData _getDutyIcon(DutyType type) => switch (type) {
    DutyType.roomCleaning => LucideIcons.home,
    DutyType.diningCleanup => LucideIcons.utensils,
    DutyType.bazarDuty => LucideIcons.shoppingCart,
    DutyType.garbageDisposal => LucideIcons.trash2,
    DutyType.cooking => LucideIcons.chefHat,
  };

  String _getDutyName(DutyType type) => switch (type) {
    DutyType.roomCleaning => 'Room Cleaning',
    DutyType.diningCleanup => 'Dining Cleanup',
    DutyType.bazarDuty => 'Bazar Duty',
    DutyType.garbageDisposal => 'Garbage Disposal',
    DutyType.cooking => 'Cooking',
  };

  Future<void> _quickSetup(List members) async {
    HapticService.success();
    final memberIds = members.map((m) => m.id as String).toList();

    if (memberIds.isEmpty) {
      showErrorToast(context, 'No members found. Add members first.');
      return;
    }

    final notifier = ref.read(dutySchedulesProvider.notifier);
    await notifier.createSchedule(
      type: DutyType.roomCleaning,
      memberIds: memberIds,
      rotationDays: 1,
    );
    await notifier.createSchedule(
      type: DutyType.diningCleanup,
      memberIds: memberIds,
      rotationDays: 1,
    );
    await notifier.createSchedule(
      type: DutyType.garbageDisposal,
      memberIds: memberIds,
      rotationDays: 2,
    );
    await ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();

    if (mounted) showSuccessToast(context, 'Duty schedules created!');
  }

  void _showCompleteSheet(DutyAssignment duty) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DutyCompletionSheet(duty: duty),
    );
  }

  void _showAddScheduleSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddScheduleSheet(),
    );
  }

  void _showDisputeSheet(DutyAssignment duty) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DutyDisputeSheet(duty: duty),
    );
  }

  bool _isAdmin() {
    final currentMember = ref.read(currentMemberProvider);
    return currentMember?.role == MemberRole.superAdmin ||
        currentMember?.role == MemberRole.admin;
  }

  Future<void> _approveDuty(DutyAssignment duty) async {
    HapticService.success();
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .approveDuty(
          dutyId: duty.id,
          reviewedBy: ref.read(currentMemberIdProvider),
          adminNotes: 'Approved',
        );
    if (mounted) showSuccessToast(context, 'Duty approved ✓');
  }

  Future<void> _rejectDuty(DutyAssignment duty) async {
    HapticService.warning();
    await ref
        .read(dutyAssignmentsProvider.notifier)
        .rejectDuty(
          dutyId: duty.id,
          reviewedBy: ref.read(currentMemberIdProvider),
          adminNotes: 'Rejected - needs to be redone',
        );
    if (mounted) showErrorToast(context, 'Duty rejected');
  }
}

// ==================== Add Schedule Sheet ====================

class _AddScheduleSheet extends ConsumerStatefulWidget {
  const _AddScheduleSheet();

  @override
  ConsumerState<_AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends ConsumerState<_AddScheduleSheet> {
  DutyType _selectedType = DutyType.roomCleaning;
  int _rotationDays = 1;
  final Set<String> _selectedMembers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() => _selectedMembers.addAll(members.map((m) => m.id)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        _sheetHandle(),
        16.heightBox,
        'Create Duty Schedule'.text.xl2.color(AppColors.textPrimaryDark).make(),
        16.heightBox,

        'Duty Type'.text.sm.color(AppColors.textSecondaryDark).make(),
        8.heightBox,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: DutyType.values
              .map(
                (type) => ChoiceChip(
                  selected: _selectedType == type,
                  label: _getDutyName(type).text.make(),
                  onSelected: (_) {
                    HapticService.selectionTick();
                    setState(() => _selectedType = type);
                  },
                ),
              )
              .toList(),
        ),
        16.heightBox,

        'Rotation Interval'.text.sm.color(AppColors.textSecondaryDark).make(),
        8.heightBox,
        Wrap(
          spacing: AppSpacing.sm,
          children: [1, 2, 3, 7]
              .map(
                (days) => ChoiceChip(
                  selected: _rotationDays == days,
                  label: '$days day${days > 1 ? 's' : ''}'.text.make(),
                  onSelected: (_) {
                    HapticService.selectionTick();
                    setState(() => _rotationDays = days);
                  },
                ),
              )
              .toList(),
        ),
        16.heightBox,

        'Members in Rotation'.text.sm.color(AppColors.textSecondaryDark).make(),
        8.heightBox,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: members
              .map(
                (m) => FilterChip(
                  selected: _selectedMembers.contains(m.id),
                  label: m.name.text.make(),
                  onSelected: (s) {
                    HapticService.selectionTick();
                    setState(
                      () => s
                          ? _selectedMembers.add(m.id)
                          : _selectedMembers.remove(m.id),
                    );
                  },
                ),
              )
              .toList(),
        ),
        24.heightBox,

        GFPrimaryButton(
          text: 'Create Schedule',
          icon: LucideIcons.check,
          onPressed: _create,
        ),
        16.heightBox,
      ]),
    );
  }

  String _getDutyName(DutyType type) => switch (type) {
    DutyType.roomCleaning => 'Room Cleaning',
    DutyType.diningCleanup => 'Dining Cleanup',
    DutyType.bazarDuty => 'Bazar Duty',
    DutyType.garbageDisposal => 'Garbage',
    DutyType.cooking => 'Cooking',
  };

  void _create() {
    if (_selectedMembers.isEmpty) return;
    HapticService.success();

    ref
        .read(dutySchedulesProvider.notifier)
        .createSchedule(
          type: _selectedType,
          memberIds: _selectedMembers.toList(),
          rotationDays: _rotationDays,
        );
    ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();

    Navigator.pop(context);
    showSuccessToast(context, 'Schedule created ✓');
  }
}

// ==================== Duty Completion Sheet ====================

class _DutyCompletionSheet extends ConsumerStatefulWidget {
  final DutyAssignment duty;
  const _DutyCompletionSheet({required this.duty});

  @override
  ConsumerState<_DutyCompletionSheet> createState() =>
      _DutyCompletionSheetState();
}

class _DutyCompletionSheetState extends ConsumerState<_DutyCompletionSheet> {
  final List<String> _photoUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _pickPhoto(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
      HapticService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        _sheetHandle(),
        16.heightBox,

        HStack([
          const Icon(LucideIcons.checkCircle, color: AppColors.moneyPositive),
          8.widthBox,
          'Complete Duty'.text.xl2.color(AppColors.textPrimaryDark).make(),
        ]),
        4.heightBox,
        'Add photo proof to mark this duty as complete'.text.sm
            .color(AppColors.textSecondaryDark)
            .make(),
        16.heightBox,

        // Photo Grid
        GFAppCard(
          borderColor: _photoUrls.isEmpty
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.moneyPositive.withValues(alpha: 0.3),
          child: VStack([
            HStack([
              Icon(
                LucideIcons.camera,
                color: _photoUrls.isEmpty
                    ? AppColors.warning
                    : AppColors.moneyPositive,
                size: 18,
              ),
              8.widthBox,
              (_photoUrls.isEmpty
                      ? 'Photo Required'
                      : '${_photoUrls.length} photo(s) added')
                  .text
                  .color(
                    _photoUrls.isEmpty
                        ? AppColors.warning
                        : AppColors.moneyPositive,
                  )
                  .make()
                  .expand(),
            ]),
            if (_photoUrls.isNotEmpty) ...[
              8.heightBox,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _photoUrls
                    .asMap()
                    .entries
                    .map(
                      (e) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              e.value,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: AppColors.primary.withValues(alpha: 0.2),
                                child: const Icon(
                                  LucideIcons.image,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _photoUrls.removeAt(e.key)),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.x,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
            12.heightBox,
            HStack([
              GFButton(
                onPressed: () => _pickPhoto(ImageSource.camera),
                text: 'Camera',
                icon: const Icon(
                  LucideIcons.camera,
                  size: 16,
                  color: Colors.white,
                ),
                color: AppColors.primary,
                size: GFSize.SMALL,
              ).expand(),
              8.widthBox,
              GFButton(
                onPressed: () => _pickPhoto(ImageSource.gallery),
                text: 'Gallery',
                icon: const Icon(
                  LucideIcons.image,
                  size: 16,
                  color: Colors.white,
                ),
                color: AppColors.secondary,
                size: GFSize.SMALL,
              ).expand(),
            ]),
          ]),
        ),
        24.heightBox,

        GFPrimaryButton(
          text: 'Complete Duty',
          icon: LucideIcons.check,
          isLoading: _isSubmitting,
          onPressed: _photoUrls.isEmpty ? null : _submit,
        ),
        16.heightBox,
      ]),
    );
  }

  Future<void> _submit() async {
    if (_photoUrls.isEmpty) return;
    setState(() => _isSubmitting = true);

    await ref
        .read(dutyAssignmentsProvider.notifier)
        .markComplete(widget.duty.id, proofImagePath: _photoUrls.join(','));

    HapticService.success();
    if (mounted) {
      Navigator.pop(context);
      showSuccessToast(context, 'Duty completed with photo proof ✓');
    }
  }
}

// ==================== Duty Dispute Sheet ====================

class _DutyDisputeSheet extends ConsumerStatefulWidget {
  final DutyAssignment duty;
  const _DutyDisputeSheet({required this.duty});

  @override
  ConsumerState<_DutyDisputeSheet> createState() => _DutyDisputeSheetState();
}

class _DutyDisputeSheetState extends ConsumerState<_DutyDisputeSheet> {
  final _reasonController = TextEditingController();
  final List<String> _photoUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
      HapticService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        _sheetHandle(),
        16.heightBox,

        HStack([
          const Icon(LucideIcons.alertTriangle, color: AppColors.warning),
          8.widthBox,
          'Dispute Duty'.text.xl2.color(AppColors.textPrimaryDark).make(),
        ]),
        4.heightBox,
        'Provide evidence that this duty was not completed properly'.text.sm
            .color(AppColors.textSecondaryDark)
            .make(),
        16.heightBox,

        TextField(
          controller: _reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason for dispute',
            prefixIcon: Icon(LucideIcons.messageSquare, size: 18),
          ),
          maxLines: 3,
        ),
        16.heightBox,

        GFSecondaryButton(
          text: 'Add Photo Evidence',
          icon: LucideIcons.camera,
          onPressed: _pickPhoto,
        ),

        if (_photoUrls.isNotEmpty) ...[
          8.heightBox,
          '${_photoUrls.length} photo(s) added'.text.sm
              .color(AppColors.moneyPositive)
              .make(),
        ],
        24.heightBox,

        GFButton(
          text: 'Submit Dispute',
          icon: const Icon(
            LucideIcons.alertTriangle,
            size: 18,
            color: Colors.white,
          ),
          color: AppColors.warning,
          textColor: Colors.white,
          shape: GFButtonShape.pills,
          size: GFSize.LARGE,
          blockButton: true,
          onPressed: _isSubmitting ? null : _submit,
        ),
        16.heightBox,
      ]),
    );
  }

  Future<void> _submit() async {
    if (_reasonController.text.isEmpty) {
      showErrorToast(context, 'Provide a reason');
      return;
    }

    setState(() => _isSubmitting = true);
    HapticService.warning();

    await ref
        .read(dutyAssignmentsProvider.notifier)
        .disputeDuty(
          dutyId: widget.duty.id,
          disputedBy: ref.read(currentMemberIdProvider),
          reason: _reasonController.text,
          disputePhotoPath: _photoUrls.isNotEmpty ? _photoUrls.join(',') : null,
        );

    if (mounted) {
      Navigator.pop(context);
      showInfoToast(context, 'Dispute submitted for admin review');
    }
  }
}

// ==================== Helpers ====================

Widget _sheetHandle() {
  return Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.borderDark,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}
