import 'package:flutter/material.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// One row in a [BookingStepOverlay]'s checklist.
class BookingStep {
  const BookingStep(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

/// The "please wait" card shown over a checkout screen while a booking step
/// (block, then confirm/book) is in flight — deliberately a step-by-step
/// checklist rather than the app's usual `TravelLoadingIndicator`, since
/// this is the one moment in the app where showing concrete progress ("your
/// seat is held", "payment confirmed") matters more than a calming
/// animation. `TravelLoadingIndicator` keeps serving every other loading
/// state.
///
/// [currentStep] is the 0-based index of the step currently in progress
/// (spinning); steps before it read as done, steps after as pending. The
/// step list itself has no real per-step signal from the backend — the
/// underlying block/book calls are each a single atomic call — so the
/// caller's provider (`BusCheckoutProvider`, `FlightCheckoutProvider`) paces
/// `currentStep` on a timer while the real call runs underneath. Lives in
/// `lib/core/widgets/` (not a module folder) since both bus and flights
/// checkout screens use it — see `docs/architecture.md` §1.
class BookingStepOverlay extends StatelessWidget {
  const BookingStepOverlay({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.steps,
    required this.currentStep,
    required this.footerIcon,
    required this.footerText,
    required this.footerColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<BookingStep> steps;
  final int currentStep;
  final IconData footerIcon;
  final String footerText;
  final Color footerColor;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    // The 5-step "booking your trip" card is tall enough to overflow on
    // shorter screens — bound the card to the available height and let its
    // content scroll internally rather than clipping/overflowing.
    final maxCardHeight = MediaQuery.sizeOf(context).height * 0.85;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.45),
        // This overlay sits as a sibling of the Scaffold in the checkout
        // screen's Stack, not a descendant of it — without its own Material
        // ancestor here, text/ink rendering picks up debug-mode fallback
        // styling (e.g. the stray underline under every line of text).
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              constraints:
                  BoxConstraints(maxWidth: 360, maxHeight: maxCardHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.elevated,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Avatar(icon: icon, color: primary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: AppTypography.titleSize,
                        fontWeight: AppTypography.titleWeight,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: AppTypography.bodySize,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < steps.length; i++) ...[
                            _StepRow(
                              step: steps[i],
                              isDone: i < currentStep,
                              isActive: i == currentStep,
                              primary: primary,
                            ),
                            if (i != steps.length - 1)
                              Padding(
                                padding: const EdgeInsets.only(left: 11.5),
                                child: Container(
                                  width: 1.5,
                                  height: 16,
                                  color: i < currentStep
                                      ? AppColors.success
                                      : AppColors.border,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: footerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(footerIcon, size: 16, color: footerColor),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              footerText,
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: AppTypography.captionSize,
                                color: footerColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle,
                  color: AppColors.success, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.isDone,
    required this.isActive,
    required this.primary,
  });

  final BookingStep step;
  final bool isDone;
  final bool isActive;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDone
        ? AppColors.success
        : isActive
            ? primary
            : Colors.grey.shade500;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 23,
          height: 23,
          child: isDone
              ? const Icon(Icons.check_circle,
                  color: AppColors.success, size: 23)
              : isActive
                  ? Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: primary),
                    )
                  : const Icon(Icons.radio_button_unchecked,
                      color: AppColors.border, size: 23),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppTypography.labelSize,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: AppTypography.captionSize,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
