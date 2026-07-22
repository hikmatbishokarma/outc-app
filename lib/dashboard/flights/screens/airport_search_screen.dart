import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:outc/dashboard/flights/providers/recent_airports_store.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';

enum AirportSearchField { origin, destination }

/// What changed by the time the screen is popped. Only the field(s) the
/// user actually picked in this session are non-null — the caller applies
/// whichever is present and leaves the other untouched.
class AirportSearchResult {
  const AirportSearchResult({this.origin, this.destination});

  final Datum? origin;
  final Datum? destination;
}

/// Combined FROM+TO airport picker (specs/0004): both fields are shown at
/// once, one editable, one visible-but-disabled. Picking the origin
/// auto-advances to the destination when it's still empty, matching a
/// premium single-flow booking UX. Reuses the exact same airport search
/// endpoint as the legacy `SelectCity`/`ToSelectCity` screens (untouched,
/// still used by `search_cars.dart`) — no API/model change here.
class AirportSearchScreen extends StatefulWidget {
  const AirportSearchScreen({
    super.key,
    required this.initialField,
    this.initialOrigin,
    this.initialDestination,
  });

  final AirportSearchField initialField;
  final Datum? initialOrigin;
  final Datum? initialDestination;

  @override
  State<AirportSearchScreen> createState() => _AirportSearchScreenState();
}

class _AirportSearchScreenState extends State<AirportSearchScreen> {
  late AirportSearchField _activeField = widget.initialField;
  Datum? _origin;
  Datum? _destination;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  List<Datum> _results = [];
  List<Datum> _recent = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _origin = widget.initialOrigin;
    _destination = widget.initialDestination;
    _loadRecent();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final recent = await RecentAirportsStore.getRecent();
    if (mounted) setState(() => _recent = recent);
  }

  Future<void> _onQueryChanged(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await _fetchAirports(trimmed);
    if (!mounted) return;
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  Future<List<Datum>> _fetchAirports(String query) async {
    final url = Uri.parse('https://outc.in/api/v1/flights/updatedAirPort/search/$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((item) => Datum.fromJson(item)).toList();
    }
    return [];
  }

  void _switchActiveField(AirportSearchField field) {
    if (_activeField == field) return;
    setState(() {
      _activeField = field;
      _controller.clear();
      _results = [];
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  Future<void> _selectAirport(Datum airport) async {
    await RecentAirportsStore.addRecent(airport);
    if (!mounted) return;

    if (_activeField == AirportSearchField.origin) {
      _origin = airport;
      if (_destination == null) {
        _switchActiveField(AirportSearchField.destination);
        return;
      }
    } else {
      _destination = airport;
    }
    // Always return everything picked so far in this screen (not just the
    // field that changed in this last tap) — otherwise picking TO right
    // after auto-advancing from FROM would report FROM as unchanged/null
    // and the caller would never persist it.
    Navigator.of(context).pop(AirportSearchResult(origin: _origin, destination: _destination));
  }

  @override
  Widget build(BuildContext context) {
    final showRecent = _controller.text.trim().isEmpty && _recent.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  _AirportFieldBox(
                    isActive: _activeField == AirportSearchField.origin,
                    leadingIcon: Icons.arrow_back,
                    onLeadingTap: () => Navigator.of(context).pop(),
                    onTap: () => _switchActiveField(AirportSearchField.origin),
                    placeholder: 'From',
                    airport: _origin,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onQueryChanged,
                  ),
                  const SizedBox(height: 12),
                  _AirportFieldBox(
                    isActive: _activeField == AirportSearchField.destination,
                    leadingIcon: Icons.flight,
                    onTap: () => _switchActiveField(AirportSearchField.destination),
                    placeholder: 'To',
                    airport: _destination,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onQueryChanged,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: showRecent
                    ? _RecentSearchesList(
                        key: const ValueKey('recent'),
                        recent: _recent,
                        onSelect: _selectAirport,
                      )
                    : _SearchResultsList(
                        key: const ValueKey('results'),
                        results: _results,
                        isLoading: _isSearching,
                        hasQuery: _controller.text.trim().isNotEmpty,
                        onSelect: _selectAirport,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AirportFieldBox extends StatelessWidget {
  const _AirportFieldBox({
    required this.isActive,
    required this.leadingIcon,
    required this.onTap,
    required this.placeholder,
    required this.airport,
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
  final Datum? airport;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  bool get _hasAirport => airport != null;

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
            color: isActive ? Flights_Colours.strongRed : Colors.grey.shade300,
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
                  color: isActive ? Flights_Colours.strongRed : Colors.grey.shade500,
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
                      cursorColor: Flights_Colours.strongRed,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: placeholder,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade500,
                        ),
                      ),
                    )
                  : (_hasAirport
                      ? RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
                            children: [
                              TextSpan(
                                text: '${airport!.airportCode}  ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: '${airport!.city}  ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              if (airport!.airportDesc != null && airport!.airportDesc!.isNotEmpty)
                                TextSpan(
                                  text: airport!.airportDesc,
                                  style: TextStyle(color: Colors.grey.shade500),
                                )
                              else if (airport!.country != null)
                                TextSpan(
                                  text: airport!.country,
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                            ],
                          ),
                        )
                      : Text(
                          placeholder,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.grey.shade500,
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSearchesList extends StatelessWidget {
  const _RecentSearchesList({super.key, required this.recent, required this.onSelect});

  final List<Datum> recent;
  final ValueChanged<Datum> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        Text(
          'RECENT SEARCHES',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        for (final airport in recent)
          InkWell(
            onTap: () => onSelect(airport),
            child: Container(
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      airport.airportCode ?? '',
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          airport.city ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (airport.airportDesc != null && airport.airportDesc!.isNotEmpty)
                          Text(
                            airport.airportDesc!,
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
          ),
      ],
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    super.key,
    required this.results,
    required this.isLoading,
    required this.hasQuery,
    required this.onSelect,
  });

  final List<Datum> results;
  final bool isLoading;
  final bool hasQuery;
  final ValueChanged<Datum> onSelect;

  @override
  Widget build(BuildContext context) {
    if (!hasQuery) return const SizedBox.shrink();
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (results.isEmpty) {
      return Center(
        child: Text(
          'No airports found',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.grey.shade600),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final airport = results[index];
        return InkWell(
          onTap: () => onSelect(airport),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.flight_takeoff, size: 22, color: Flights_Colours.strongRed),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${airport.airportCode}  ',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: airport.city ?? ''),
                          ],
                        ),
                        style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black87),
                      ),
                      if (airport.airportDesc != null && airport.airportDesc!.isNotEmpty)
                        Text(
                          [airport.airportDesc, airport.country].whereType<String>().join(' · '),
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
