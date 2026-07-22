import 'package:flutter/material.dart';

/// Generic animated segmented control: a row of equal-width, tappable labels
/// with a sliding pill indicator behind the selected one. Not tied to any
/// module's colors or copy — callers supply [labels], [selectedIndex], and
/// [onChanged].
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.activeColor,
    this.inactiveTextColor,
    this.backgroundColor,
    this.height = 48,
    this.borderRadius = 14,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? activeColor;
  final Color? inactiveTextColor;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = activeColor ?? colorScheme.primary;
    final inactiveText = inactiveTextColor ?? colorScheme.onSurfaceVariant;
    final background = backgroundColor ?? colorScheme.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / labels.length;
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  labels.length == 1
                      ? 0
                      : -1 + (2 * selectedIndex) / (labels.length - 1),
                  0,
                ),
                child: Container(
                  width: segmentWidth - 4,
                  height: height - 8,
                  decoration: BoxDecoration(
                    color: active,
                    borderRadius: BorderRadius.circular(borderRadius - 4),
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (index) {
                  final isSelected = index == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(index),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : inactiveText,
                          ),
                          child: Text(
                            labels[index],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
