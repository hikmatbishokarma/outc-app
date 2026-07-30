import 'package:flutter/material.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// One FROM or TO field: small caps label, city + airport-code line, and a
/// country subtitle. Tapping opens the caller-supplied picker.
class AirportSelector extends StatelessWidget {
  const AirportSelector({
    super.key,
    required this.label,
    required this.city,
    required this.airportCode,
    required this.country,
    required this.onTap,
    this.compact = false,
    this.icon,
  });

  final String label;
  final String? city;
  final String? airportCode;
  final String? country;
  final VoidCallback onTap;

  /// Tighter font sizing for side-by-side FROM/TO layouts, where each field
  /// only gets half the card's width.
  final bool compact;

  /// Unused — kept optional so existing call sites that still pass an icon
  /// don't need to change; the boxed field style no longer shows one.
  final IconData? icon;

  bool get _hasSelection => city != null && city!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            _hasSelection ? city! : 'Select City',
            maxLines: 1,
            style: TextStyle(
              fontSize: compact ? 15 : 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (_hasSelection)
            Text(
              [
                if (airportCode != null && airportCode!.isNotEmpty) airportCode,
                if (country != null && country!.isNotEmpty) country,
              ].join(' · '),
              maxLines: 1,
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
