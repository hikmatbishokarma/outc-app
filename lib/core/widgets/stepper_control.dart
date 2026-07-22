import 'package:flutter/material.dart';

/// Generic +/- counter control. [min]/[max] are enforced symmetrically on
/// both directions so a caller can never end up in a state where one button
/// is silently dead (unlike a naive `if (value > 1)` decrement guard).
class StepperControl extends StatelessWidget {
  const StepperControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.label,
    this.sublabel,
    this.accentColor,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String? label;
  final String? sublabel;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Theme.of(context).colorScheme.primary;
    final canDecrement = value > min;
    final canIncrement = value < max;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (label != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (sublabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      sublabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Row(
          children: [
            _StepperButton(
              icon: Icons.remove,
              enabled: canDecrement,
              color: color,
              onTap: () => onChanged(value - 1),
            ),
            SizedBox(
              width: 36,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.add,
              enabled: canIncrement,
              color: color,
              onTap: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? color : Colors.grey.shade300,
            width: 1.4,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? color : Colors.grey.shade400,
        ),
      ),
    );
  }
}
