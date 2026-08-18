import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/travel_loading_indicator.dart';

/// The four renderings of [AsyncState]'s non-`AsyncData` variants (spec
/// 0012), kept in one file rather than one-per-file — they're always
/// reasoned about together (as arms of the same switch) and share one full-
/// bleed centered layout, so splitting them would only push that shared
/// layout into a fifth file for no benefit.
class _FeedbackScaffold extends StatelessWidget {
  const _FeedbackScaffold({
    required this.body,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final Widget body;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            body,
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
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: AppTypography.bodySize,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The one loading treatment app-wide: spinner + optional label.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label});
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TravelLoadingIndicator(
      size: 220,
      caption: label ?? 'Loading',
    );
  }
}

/// A thrown exception or non-2xx response. Message + retry.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return _FeedbackScaffold(
      body: SvgPicture.asset('images/illustrations/error.svg', height: 160, width: 160),
      title: title,
      message: message,
      actionLabel: onRetry == null ? null : retryLabel,
      onAction: onRetry,
    );
  }
}

/// A successful response with zero results — distinct from [ErrorState].
/// Defaults to the app's existing "no data" illustration.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.title = 'Nothing here yet',
    this.message,
    this.illustrationAsset = 'images/nodatafound.png',
    this.illustrationSize = 200,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final String illustrationAsset;
  final double illustrationSize;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _FeedbackScaffold(
      body: Image.asset(illustrationAsset, height: illustrationSize, width: illustrationSize),
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// The connectivity check failed before the network call was attempted —
/// distinct copy/icon from [ErrorState] since it's a different situation.
class NoInternetState extends StatelessWidget {
  const NoInternetState({
    super.key,
    this.title = 'No internet connection',
    this.message = 'Check your connection and try again.',
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return _FeedbackScaffold(
      body: SvgPicture.asset('images/illustrations/no_internet.svg', height: 160, width: 160),
      title: title,
      message: message,
      actionLabel: onRetry == null ? null : retryLabel,
      onAction: onRetry,
    );
  }
}
