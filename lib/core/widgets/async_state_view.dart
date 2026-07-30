import 'package:flutter/material.dart';
import 'package:outc/core/state/async_state.dart';
import 'package:outc/core/widgets/empty_state.dart';
import 'package:outc/core/widgets/error_state.dart';
import 'package:outc/core/widgets/loading_state.dart';
import 'package:outc/core/widgets/no_internet_state.dart';

/// Renders an [AsyncState] as the matching one of the four shared feedback
/// widgets (spec 0012), so a screen renders purely off `state` instead of
/// hand-writing the same switch at every call site.
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.state,
    required this.dataBuilder,
    this.onRetry,
    this.loadingLabel,
    this.emptyMessage = 'No results found.',
    this.emptyIllustrationAsset = 'images/illustrations/empty_results.svg',
    this.errorMessage = 'Something went wrong. Please try again.',
  });

  final AsyncState<T> state;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final VoidCallback? onRetry;
  final String? loadingLabel;
  final String emptyMessage;
  final String emptyIllustrationAsset;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AsyncLoading<T>() => LoadingState(label: loadingLabel),
      AsyncData<T>(:final value) => dataBuilder(context, value),
      AsyncEmpty<T>() => EmptyState(
          message: emptyMessage,
          illustrationAsset: emptyIllustrationAsset,
        ),
      AsyncError<T>(:final message) =>
        ErrorState(message: message.isNotEmpty ? message : errorMessage, onRetry: onRetry),
      AsyncOffline<T>() => NoInternetState(onRetry: onRetry),
    };
  }
}
