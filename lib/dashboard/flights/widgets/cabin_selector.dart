import 'package:flutter/material.dart';

import 'package:outc/dashboard/flights/providers/flight_search_form_provider.dart';
import 'package:outc/core/theme/design_tokens.dart';

/// The 4-option cabin-class picker: selectable cards with a title,
/// description, and a selection indicator.
class CabinSelector extends StatelessWidget {
  const CabinSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final CabinClass selected;
  final ValueChanged<CabinClass> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: CabinClass.values.map((cabin) {
        final isSelected = cabin == selected;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onChanged(cabin),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 1.6 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cabin.label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cabin.description,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
