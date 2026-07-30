import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// One selection card at the top of the flight calendar screen (Departure,
/// Return, or a Multi-City leg's single date). Highlighted border when
/// [isActive]; tapping an inactive card hands focus back to the caller.
class FlightDateCard extends StatelessWidget {
  const FlightDateCard({
    super.key,
    required this.label,
    required this.date,
    required this.isActive,
    required this.onTap,
    this.placeholder = 'Select Date',
    this.dateFormat,
  });

  final String label;
  final DateTime? date;
  final bool isActive;
  final VoidCallback onTap;
  final String placeholder;

  /// Defaults to "21 Jul" + "Tue, 2026" (two lines) when null.
  final String Function(DateTime)? dateFormat;

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            width: isActive ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            if (hasDate) ...[
              Text(
                DateFormat('d MMM').format(date!),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                DateFormat('EEE, yyyy').format(date!),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade600,
                ),
              ),
            ] else
              Text(
                placeholder,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
