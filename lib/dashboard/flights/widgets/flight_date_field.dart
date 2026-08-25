import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// One date row: icon + label + formatted date, or an empty-state
/// placeholder + helper text when [date] is null (used for round trip's
/// "+ ADD RETURN DATE" affordance).
class FlightDateField extends StatelessWidget {
  const FlightDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
    this.placeholder = 'Select Date',
    this.helperText,
    this.emphasizePlaceholder = false,
    this.compact = false,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final String placeholder;
  final String? helperText;
  final bool emphasizePlaceholder;

  /// Tighter icon/font sizing for side-by-side layouts (multi-city's
  /// FROM/TO/DATE row), where this field only gets a third of the width.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.calendar_today, size: compact ? 18 : 22, color: AppColors.primary),
          SizedBox(width: compact ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasDate) ...[
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 10 : 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  // Compact mode (multi-city's 3-column FROM/TO/DATE row)
                  // only gets a third of the row's width — the full
                  // "Fri, Aug 28, 2026" format truncated to "Fri, Aug …"
                  // before the day number even rendered, so the field
                  // couldn't actually tell you which date was picked.
                  // Weekday/year aren't essential here; day+month is.
                  hasDate
                      ? (compact ? DateFormat('dd MMM').format(date!) : DateFormat.yMMMEd().format(date!))
                      : placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: hasDate ? (compact ? 13 : 16) : (compact ? 12 : 15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: !hasDate && emphasizePlaceholder
                        ? AppColors.primary
                        : Colors.black87,
                  ),
                ),
                if (!hasDate && helperText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      helperText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }
}
