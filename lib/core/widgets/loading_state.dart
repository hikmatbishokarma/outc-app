import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';

/// The one loading treatment (spec 0012) — replaces inline
/// `CircularProgressIndicator` usage in touched screens.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          if (label != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              label!,
              style: TextStyle(
                fontSize: AppTypography.bodySize,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
