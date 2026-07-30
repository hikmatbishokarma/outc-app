import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outc/core/theme/design_tokens.dart';

/// "No results" treatment (spec 0012) — e.g. no flights found, no buses on
/// this route. Distinct from [ErrorState]: an empty result set is not a
/// failure, so there's no retry action by default.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.message = 'No results found.',
    this.illustrationAsset = 'images/illustrations/empty_results.svg',
    this.action,
  });

  final String message;
  final String illustrationAsset;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(illustrationAsset, height: 160),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTypography.bodySize,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
