import 'package:flutter/material.dart';

/// The horizontal row of quick-access filter chips pinned under the trip
/// search bar — replaces a separate "Flight Results" app-bar title plus a
/// lone funnel icon buried in its actions. Reference apps (MMT etc.) put
/// this row directly under the route/date bar as *direct* filter toggles —
/// "Price: Low to High" and "Non Stop" both apply the moment you tap them,
/// no picker or intermediate sheet in between — then a "Filters" pill
/// carrying a badge with however many other filters are active. (An
/// earlier version routed "Sort" through its own small bottom sheet before
/// applying anything; that extra step is gone — every other sort option
/// (High to Low, Duration, Departure) still lives in the full Filters
/// sheet, this chip is just the one-tap shortcut for the most common one.)
/// Used identically by oneway and round trip (and, later, multi-city) so
/// this chrome doesn't drift between them.
class FlightQuickFilterBar extends StatelessWidget {
  const FlightQuickFilterBar({
    super.key,
    required this.isCheapestFirstActive,
    required this.onToggleCheapestFirst,
    required this.isNonStopActive,
    required this.onToggleNonStop,
    required this.activeFilterCount,
    required this.onTapFilters,
    this.nonStopLabel = 'Non Stop',
  });

  final bool isCheapestFirstActive;
  final VoidCallback onToggleCheapestFirst;
  final bool isNonStopActive;
  final VoidCallback onToggleNonStop;

  /// Multi-city (spec 0016) relabels this "All Direct" — "Non Stop" reads
  /// as a single-flight concept, and an itinerary's directness is really
  /// "every leg is direct."
  final String nonStopLabel;

  /// Count shown on the "Filters" pill's badge — every active filter
  /// *except* this chip and Non Stop, which already have their own chips
  /// (Non Stop still counts itself once toggled, matching the reference
  /// apps' own badge).
  final int activeFilterCount;
  final VoidCallback onTapFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _QuickChip(
              icon: Icons.swap_vert,
              label: 'Price: Low to High',
              selected: isCheapestFirstActive,
              onTap: onToggleCheapestFirst,
            ),
            const SizedBox(width: 8),
            _QuickChip(label: nonStopLabel, selected: isNonStopActive, onTap: onToggleNonStop),
            const SizedBox(width: 8),
            _FiltersButton(count: activeFilterCount, onTap: onTapFilters),
          ],
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({this.icon, required this.label, required this.selected, required this.onTap});
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? primary : Colors.grey.shade300, width: selected ? 1.4 : 1),
          color: selected ? primary.withValues(alpha: 0.08) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: selected ? primary : Colors.grey.shade700),
              const SizedBox(width: 4),
            ],
            Text(label,
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: selected ? primary : Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final active = count > 0;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? primary : Colors.grey.shade300, width: active ? 1.4 : 1),
          color: active ? primary.withValues(alpha: 0.08) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, size: 15, color: active ? primary : Colors.grey.shade700),
            const SizedBox(width: 4),
            Text('Filters', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: active ? primary : Colors.grey.shade700)),
            if (active) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(999)),
                child: Text('$count', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
