import 'package:flutter/material.dart';

import 'package:outc/core/widgets/bottom_sheet_shell.dart';
import 'package:outc/dashboard/bus/providers/bus_results_provider.dart';

/// The seven filter/sort bottom sheets for the bus results screen (spec
/// 0007). Each takes the screen's `BusResultsProvider` directly rather than
/// looking it up via `Provider.of` — simplest and avoids any doubt about
/// inherited-widget lookup across the modal route.
class BusFilterSheets {
  BusFilterSheets._();

  static void showSeatType(BuildContext context, BusResultsProvider provider) {
    _showCheckboxSheet(
      context,
      title: 'Seat Type',
      options: provider.seatTypeFacets
          .map((f) => _Option(f.type, f.count, icon: _seatTypeIcon(f.type)))
          .toList(),
      initialSelected: provider.selectedSeatTypes,
      onApply: (selected) => provider.applySelection(provider.selectedSeatTypes, selected),
      onClear: provider.clearSeatTypes,
    );
  }

  static void showTiming(BuildContext context, BusResultsProvider provider) {
    final buckets = provider.filters.departureTimes.entries
        .map((e) => _Option(e.key, e.value, icon: _timingIcon(e.key)))
        .toList();
    _showCheckboxSheet(
      context,
      title: 'Timing (Departure)',
      options: buckets,
      initialSelected: provider.selectedDepartureBuckets,
      onApply: (selected) => provider.applySelection(provider.selectedDepartureBuckets, selected),
      onClear: provider.clearDepartureBuckets,
    );
  }

  static void showAcType(BuildContext context, BusResultsProvider provider) {
    _showCheckboxSheet(
      context,
      title: 'AC / Non-AC',
      options: provider.acTypeFacets
          .map((f) => _Option(f.type, f.count, icon: _acTypeIcon(f.type)))
          .toList(),
      initialSelected: provider.selectedAcTypes,
      onApply: (selected) => provider.applySelection(provider.selectedAcTypes, selected),
      onClear: provider.clearAcTypes,
    );
  }

  static void showAmenities(BuildContext context, BusResultsProvider provider) {
    _showCheckboxSheet(
      context,
      title: 'Amenities',
      options: provider.availableAmenities
          .map((a) => _Option(a, null, icon: _amenityIcon(a)))
          .toList(),
      initialSelected: provider.selectedAmenities,
      onApply: (selected) => provider.applySelection(provider.selectedAmenities, selected),
      onClear: provider.clearAmenities,
    );
  }

  static void showBusOperators(BuildContext context, BusResultsProvider provider) {
    _showCheckboxSheet(
      context,
      title: 'Bus Operators',
      options: provider.availableOperators
          .map((o) => _Option(o, null, icon: Icons.directions_bus))
          .toList(),
      initialSelected: provider.selectedOperators,
      onApply: (selected) => provider.applySelection(provider.selectedOperators, selected),
      onClear: provider.clearOperators,
      searchable: true,
    );
  }

  static IconData _seatTypeIcon(String type) {
    switch (type) {
      case 'Sleeper':
        return Icons.bed;
      case 'Semi Sleeper':
        return Icons.weekend;
      case 'Seater':
      default:
        return Icons.event_seat;
    }
  }

  static IconData _acTypeIcon(String type) => type == 'AC' ? Icons.ac_unit : Icons.air;

  static IconData _timingIcon(String bucket) {
    switch (bucket) {
      case '12AM to 06AM':
        return Icons.bedtime;
      case '06AM to 12PM':
        return Icons.wb_sunny;
      case '12PM to 06PM':
        return Icons.light_mode;
      case '06PM to 12AM':
        return Icons.nights_stay;
      default:
        return Icons.schedule;
    }
  }

  static IconData _amenityIcon(String amenity) {
    final a = amenity.toLowerCase();
    if (a.contains('water') || a.contains('drink')) return Icons.local_drink;
    if (a.contains('charg') || a.contains('usb')) return Icons.power;
    if (a.contains('wifi')) return Icons.wifi;
    if (a.contains('read') || a.contains('light')) return Icons.lightbulb_outline;
    if (a.contains('gps') || a.contains('track')) return Icons.gps_fixed;
    if (a.contains('blanket') || a.contains('pillow') || a.contains('bed sheet')) return Icons.bed;
    if (a.contains('cctv') || a.contains('camera')) return Icons.videocam;
    if (a.contains('fire')) return Icons.local_fire_department;
    if (a.contains('first aid') || a.contains('medical')) return Icons.medical_services;
    if (a.contains('tv') || a.contains('movie')) return Icons.tv;
    if (a.contains('mask') || a.contains('sanit') || a.contains('disinfect')) return Icons.clean_hands;
    if (a.contains('host')) return Icons.person;
    if (a.contains('emergency exit')) return Icons.exit_to_app;
    if (a.contains('security') || a.contains('guard')) return Icons.security;
    if (a.contains('ticket')) return Icons.confirmation_number;
    if (a.contains('newspaper') || a.contains('magazine')) return Icons.article;
    if (a.contains('snack') || a.contains('croissant')) return Icons.fastfood;
    if (a.contains('lounge')) return Icons.chair;
    return Icons.check_circle_outline;
  }

  static void showSortBy(BuildContext context, BusResultsProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SortBySheetContent(provider: provider),
    );
  }

  static void showPriceRange(BuildContext context, BusResultsProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _PriceRangeSheetContent(provider: provider),
    );
  }

  static void showAllFilters(BuildContext context, BusResultsProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BottomSheetShell(
        title: 'All Filters',
        primaryActionLabel: 'Done',
        onPrimaryAction: () => Navigator.of(sheetContext).pop(),
        secondaryActionLabel: 'Clear All',
        onSecondaryAction: () {
          provider.clearAll();
          Navigator.of(sheetContext).pop();
        },
        primaryActionColor: Theme.of(context).colorScheme.primary,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AllFiltersRow(label: 'Seat Type', onTap: () => showSeatType(context, provider)),
            _AllFiltersRow(label: 'Timing (Departure)', onTap: () => showTiming(context, provider)),
            _AllFiltersRow(label: 'AC / Non-AC', onTap: () => showAcType(context, provider)),
            _AllFiltersRow(label: 'Sort By', onTap: () => showSortBy(context, provider)),
            _AllFiltersRow(label: 'Price Range', onTap: () => showPriceRange(context, provider)),
            _AllFiltersRow(label: 'Amenities', onTap: () => showAmenities(context, provider)),
            _AllFiltersRow(label: 'Bus Operators', onTap: () => showBusOperators(context, provider)),
          ],
        ),
      ),
    );
  }

  static void _showCheckboxSheet(
    BuildContext context, {
    required String title,
    required List<_Option> options,
    required Set<String> initialSelected,
    required ValueChanged<Set<String>> onApply,
    required VoidCallback onClear,
    bool searchable = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _CheckboxSheetContent(
        title: title,
        options: options,
        initialSelected: initialSelected,
        onApply: onApply,
        onClear: onClear,
        searchable: searchable,
      ),
    );
  }
}

class _Option {
  const _Option(this.label, this.count, {this.icon});
  final String label;
  final int? count;
  final IconData? icon;
}

class _AllFiltersRow extends StatelessWidget {
  const _AllFiltersRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}

class _CheckboxSheetContent extends StatefulWidget {
  const _CheckboxSheetContent({
    required this.title,
    required this.options,
    required this.initialSelected,
    required this.onApply,
    required this.onClear,
    required this.searchable,
  });

  final String title;
  final List<_Option> options;
  final Set<String> initialSelected;
  final ValueChanged<Set<String>> onApply;
  final VoidCallback onClear;
  final bool searchable;

  @override
  State<_CheckboxSheetContent> createState() => _CheckboxSheetContentState();
}

class _CheckboxSheetContentState extends State<_CheckboxSheetContent> {
  final Set<String> _selected = <String>{};
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = _query.isEmpty
        ? widget.options
        : widget.options.where((o) => o.label.toLowerCase().contains(_query.toLowerCase())).toList();

    return BottomSheetShell(
      title: widget.title,
      primaryActionLabel: 'Apply',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () {
        widget.onApply(_selected);
        Navigator.of(context).pop();
      },
      secondaryActionLabel: 'Clear',
      onSecondaryAction: () {
        widget.onClear();
        Navigator.of(context).pop();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.searchable)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search operators',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
          for (final option in filteredOptions)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _selected.contains(option.label),
              secondary: option.icon != null ? Icon(option.icon, color: Theme.of(context).colorScheme.primary) : null,
              title: Text(option.label),
              subtitle: option.count != null ? Text('${option.count} buses') : null,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (checked) {
                setState(() {
                  if (checked ?? false) {
                    _selected.add(option.label);
                  } else {
                    _selected.remove(option.label);
                  }
                });
              },
            ),
          if (filteredOptions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('No options found', style: TextStyle(color: Colors.grey.shade600)),
            ),
        ],
      ),
    );
  }
}

class _SortBySheetContent extends StatefulWidget {
  const _SortBySheetContent({required this.provider});
  final BusResultsProvider provider;

  @override
  State<_SortBySheetContent> createState() => _SortBySheetContentState();
}

class _SortBySheetContentState extends State<_SortBySheetContent> {
  late BusSortOption _selected = widget.provider.sortBy;

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Sort By',
      primaryActionLabel: 'Apply',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () {
        widget.provider.setSort(_selected);
        Navigator.of(context).pop();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in BusSortOption.values)
            RadioListTile<BusSortOption>(
              contentPadding: EdgeInsets.zero,
              value: option,
              groupValue: _selected,
              activeColor: Theme.of(context).colorScheme.primary,
              secondary: Icon(_sortIcon(option), color: Theme.of(context).colorScheme.primary),
              title: Text(option.label),
              onChanged: (value) => setState(() => _selected = value!),
            ),
        ],
      ),
    );
  }

  IconData _sortIcon(BusSortOption option) {
    switch (option) {
      case BusSortOption.priceLowToHigh:
        return Icons.arrow_upward;
      case BusSortOption.priceHighToLow:
        return Icons.arrow_downward;
      case BusSortOption.departureEarliest:
        return Icons.schedule;
      case BusSortOption.durationShortest:
        return Icons.timelapse;
    }
  }
}

class _PriceRangeSheetContent extends StatefulWidget {
  const _PriceRangeSheetContent({required this.provider});
  final BusResultsProvider provider;

  @override
  State<_PriceRangeSheetContent> createState() => _PriceRangeSheetContentState();
}

class _PriceRangeSheetContentState extends State<_PriceRangeSheetContent> {
  late RangeValues _range = widget.provider.priceRange;

  @override
  Widget build(BuildContext context) {
    final min = widget.provider.filters.priceMin;
    final max = widget.provider.filters.priceMax;
    final safeMax = max > min ? max : min + 1;

    return BottomSheetShell(
      title: 'Price Range',
      primaryActionLabel: 'Apply',
      primaryActionColor: Theme.of(context).colorScheme.primary,
      onPrimaryAction: () {
        widget.provider.setPriceRange(_range);
        Navigator.of(context).pop();
      },
      secondaryActionLabel: 'Clear',
      onSecondaryAction: () {
        widget.provider.clearPriceRange();
        Navigator.of(context).pop();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('₹${_range.start.toStringAsFixed(0)} - ₹${_range.end.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          RangeSlider(
            values: _range,
            min: min,
            max: safeMax,
            activeColor: Theme.of(context).colorScheme.primary,
            labels: RangeLabels(
              '₹${_range.start.toStringAsFixed(0)}',
              '₹${_range.end.toStringAsFixed(0)}',
            ),
            onChanged: (values) => setState(() => _range = values),
          ),
          Wrap(
            spacing: 8,
            children: [
              _presetChip('Under ₹1000', min, 1000, safeMax),
              _presetChip('₹1000-3000', 1000, 3000, safeMax),
              _presetChip('₹3000-5000', 3000, 5000, safeMax),
              _presetChip('Above ₹5000', 5000, safeMax, safeMax),
            ],
          ),
        ],
      ),
    );
  }

  Widget _presetChip(String label, double start, double end, double sheetMax) {
    final clampedStart = start.clamp(widget.provider.filters.priceMin, sheetMax);
    final clampedEnd = end.clamp(widget.provider.filters.priceMin, sheetMax);
    return ActionChip(
      label: Text(label),
      onPressed: () => setState(() => _range = RangeValues(clampedStart, clampedEnd)),
    );
  }
}
