import 'package:flutter/material.dart';

/// A row of compact outlined toggle chips — one per label, selected one
/// shown with a colored border/text on a white background (MMT-style: light
/// and compact, not a large filled/sliding-pill control). Not tied to any
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
    this.height = 38,
    this.borderRadius = 8,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? activeColor;
  final Color? inactiveTextColor;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = activeColor ?? colorScheme.primary;
    final inactiveText = inactiveTextColor ?? Colors.grey.shade700;

    return Row(
      children: List.generate(labels.length, (index) {
        final isSelected = index == selectedIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 8),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: isSelected ? active : Colors.grey.shade300,
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Text(
                  labels[index],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? active : inactiveText,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
