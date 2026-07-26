import 'package:flutter/material.dart';

import 'package:outc/dashboard/bus/models/bus_city_model.dart';
import 'package:outc/dashboard/bus/services/bus_service.dart';
import 'package:outc/widgets/colors/colors.dart';

enum BusCitySearchField { origin, destination }

/// What changed by the time the screen is popped — mirrors
/// `AirportSearchResult` in the flights module (specs/0004), adapted for
/// bus's own `searchBusCities` endpoint and `BusCity` model.
class BusCitySearchResult {
  const BusCitySearchResult({this.origin, this.destination});

  final BusCity? origin;
  final BusCity? destination;
}

class BusCitySearchScreen extends StatefulWidget {
  const BusCitySearchScreen({
    super.key,
    required this.initialField,
    this.initialOrigin,
    this.initialDestination,
  });

  final BusCitySearchField initialField;
  final BusCity? initialOrigin;
  final BusCity? initialDestination;

  @override
  State<BusCitySearchScreen> createState() => _BusCitySearchScreenState();
}

class _BusCitySearchScreenState extends State<BusCitySearchScreen> {
  final BusService _service = BusService();
  late BusCitySearchField _activeField = widget.initialField;
  BusCity? _origin;
  BusCity? _destination;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  List<BusCity> _results = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _origin = widget.initialOrigin;
    _destination = widget.initialDestination;
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onQueryChanged(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await _service.searchCities(trimmed);
    if (!mounted) return;
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  void _switchActiveField(BusCitySearchField field) {
    if (_activeField == field) return;
    setState(() {
      _activeField = field;
      _controller.clear();
      _results = [];
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _selectCity(BusCity city) {
    if (_activeField == BusCitySearchField.origin) {
      _origin = city;
      if (_destination == null) {
        _switchActiveField(BusCitySearchField.destination);
        return;
      }
    } else {
      _destination = city;
    }
    Navigator.of(context).pop(BusCitySearchResult(origin: _origin, destination: _destination));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  _BusCityFieldBox(
                    isActive: _activeField == BusCitySearchField.origin,
                    leadingIcon: Icons.arrow_back,
                    onLeadingTap: () => Navigator.of(context).pop(),
                    onTap: () => _switchActiveField(BusCitySearchField.origin),
                    placeholder: 'From',
                    city: _origin,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onQueryChanged,
                  ),
                  const SizedBox(height: 12),
                  _BusCityFieldBox(
                    isActive: _activeField == BusCitySearchField.destination,
                    leadingIcon: Icons.directions_bus,
                    onTap: () => _switchActiveField(BusCitySearchField.destination),
                    placeholder: 'To',
                    city: _destination,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onQueryChanged,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _CityResultsList(
                results: _results,
                isLoading: _isSearching,
                hasQuery: _controller.text.trim().isNotEmpty,
                onSelect: _selectCity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusCityFieldBox extends StatelessWidget {
  const _BusCityFieldBox({
    required this.isActive,
    required this.leadingIcon,
    required this.onTap,
    required this.placeholder,
    required this.city,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onLeadingTap,
  });

  final bool isActive;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final VoidCallback? onLeadingTap;
  final String placeholder;
  final BusCity? city;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  bool get _hasCity => city != null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: isActive ? null : onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? Colours.strongRed : Colors.grey.shade300,
            width: isActive ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            InkWell(
              customBorder: const CircleBorder(),
              onTap: onLeadingTap,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  leadingIcon,
                  size: 22,
                  color: isActive ? Colours.strongRed : Colors.grey.shade500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: isActive
                  ? TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      cursorColor: Colours.strongRed,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: placeholder,
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                      ),
                    )
                  : (_hasCity
                      ? Text(
                          city!.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        )
                      : Text(
                          placeholder,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityResultsList extends StatelessWidget {
  const _CityResultsList({
    required this.results,
    required this.isLoading,
    required this.hasQuery,
    required this.onSelect,
  });

  final List<BusCity> results;
  final bool isLoading;
  final bool hasQuery;
  final ValueChanged<BusCity> onSelect;

  @override
  Widget build(BuildContext context) {
    if (!hasQuery) return const SizedBox.shrink();
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (results.isEmpty) {
      return Center(
        child: Text('No cities found', style: TextStyle(color: Colors.grey.shade600)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final city = results[index];
        return InkWell(
          onTap: () => onSelect(city),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 22, color: Colours.strongRed),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        city.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
