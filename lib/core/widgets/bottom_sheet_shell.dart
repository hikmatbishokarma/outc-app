import 'package:flutter/material.dart';
import 'package:outc/core/widgets/glass_surface.dart';

/// Generic modal-bottom-sheet chrome: rounded top corners, a drag handle,
/// a title row with a close button, a scrollable [body] slot, and a fixed
/// primary-action button pinned to the bottom. Callers own their own
/// content and just supply [body]/[primaryActionLabel]/[onPrimaryAction].
///
/// Open with:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => BottomSheetShell(...),
/// );
/// ```
///
/// [glass] swaps the solid white background for the shared [GlassSurface]
/// treatment — reserved for the one sheet per flow called out in
/// `docs/architecture.md` §4 (currently the bus seat-selection legend
/// sheet). Leave it false everywhere else; this is the only place that
/// treatment is wired in, so a new hero sheet just passes `glass: true`
/// instead of copy-pasting a `BackdropFilter`.
class BottomSheetShell extends StatelessWidget {
  const BottomSheetShell({
    super.key,
    required this.title,
    required this.body,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    this.primaryActionColor,
    this.maxHeightFraction = 0.85,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.glass = false,
  });

  final String title;
  final Widget body;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final Color? primaryActionColor;
  final double maxHeightFraction;
  final bool glass;

  /// Optional second (e.g. "Clear") action. Only rendered when both this and
  /// [onSecondaryAction] are supplied — otherwise the primary button keeps
  /// its original full-width layout, so existing callers are unaffected.
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  static const _topRadius = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  @override
  Widget build(BuildContext context) {
    final actionColor = primaryActionColor ?? Theme.of(context).colorScheme.primary;

    final content = _content(context, actionColor);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * maxHeightFraction,
        ),
        child: glass
            ? ClipRRect(
                borderRadius: _topRadius,
                child: GlassSurface(
                  borderRadius: 0,
                  padding: EdgeInsets.zero,
                  child: content,
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: _topRadius,
                ),
                child: content,
              ),
      ),
    );
  }

  Widget _content(BuildContext context, Color actionColor) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 8, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: (secondaryActionLabel != null && onSecondaryAction != null)
                  ? Row(
                      children: [
                        TextButton(
                          onPressed: onSecondaryAction,
                          child: Text(
                            secondaryActionLabel!,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: actionColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: onPrimaryAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: actionColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                primaryActionLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onPrimaryAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: actionColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          primaryActionLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
  }
}
