import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:outc/core/state/async_state.dart';
import 'package:outc/core/widgets/error_state.dart';
import 'package:outc/core/widgets/no_internet_state.dart';
import 'package:outc/core/widgets/stepper_control.dart';
import 'package:outc/dashboard/bus/models/bus_city_model.dart';
import 'package:outc/dashboard/bus/providers/bus_search_provider.dart';
import 'package:outc/dashboard/bus/screens/bus_city_search_screen.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/screens/bus_date_calendar_screen.dart';
import 'package:outc/dashboard/bus/screens/bus_results_screen.dart';

/// Bus search screen (spec 0006, one-way only). Replaces the old
/// `Bus_Dashboard` — no nested `MaterialApp`, inherits the app's own
/// theme/navigator per `docs/architecture.md` §1.
class BusSearchScreen extends StatelessWidget {
  const BusSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusSearchProvider(),
      child: const _BusSearchView(),
    );
  }
}

class _BusSearchView extends StatelessWidget {
  const _BusSearchView();

  @override
  Widget build(BuildContext context) {
    return Consumer<BusSearchProvider>(
      builder: (context, form, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Bus Booking'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            _CityField(
                              icon: Icons.location_on,
                              label: 'From',
                              city: form.originCity,
                              onTap: () => _pickCities(context, form, BusCitySearchField.origin),
                            ),
                            const SizedBox(height: 10),
                            _CityField(
                              icon: Icons.directions_bus,
                              label: 'To',
                              city: form.destinationCity,
                              onTap: () => _pickCities(context, form, BusCitySearchField.destination),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 8,
                          child: _SwapCitiesButton(onTap: form.swapCities),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _DateField(
                      date: form.journeyDate,
                      onTap: () => _pickDate(context, form),
                    ),
                    const SizedBox(height: 16),
                    StepperControl(
                      value: form.passengerCount,
                      min: BusSearchProvider.minPassengers,
                      max: BusSearchProvider.maxPassengers,
                      label: 'Passengers',
                      accentColor: Theme.of(context).colorScheme.primary,
                      onChanged: form.setPassengerCount,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed:
                          form.state is AsyncLoading ? null : () => _onSearch(context, form),
                      icon: form.state is AsyncLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search, color: Colors.white),
                      label: Text(
                        form.state is AsyncLoading ? 'Searching...' : 'Search Buses',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    if (form.state is AsyncError<BusSearchResponse>)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ErrorState(
                          message: (form.state as AsyncError<BusSearchResponse>).message,
                          onRetry: () => _onSearch(context, form),
                        ),
                      ),
                    if (form.state is AsyncOffline<BusSearchResponse>)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: NoInternetState(onRetry: () => _onSearch(context, form)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCities(
    BuildContext context,
    BusSearchProvider form,
    BusCitySearchField initialField,
  ) async {
    final result = await Navigator.of(context).push<BusCitySearchResult>(
      MaterialPageRoute(
        builder: (_) => BusCitySearchScreen(
          initialField: initialField,
          initialOrigin: form.originCity,
          initialDestination: form.destinationCity,
        ),
      ),
    );
    if (result == null) return;
    if (result.origin != null) form.setOrigin(result.origin!);
    if (result.destination != null) form.setDestination(result.destination!);
  }

  Future<void> _pickDate(BuildContext context, BusSearchProvider form) async {
    final picked = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (_) => BusDateCalendarScreen(
          initialDate: form.journeyDate,
          minDate: DateTime.now(),
        ),
      ),
    );
    if (picked != null) form.setDate(picked);
  }

  Future<void> _onSearch(BuildContext context, BusSearchProvider form) async {
    if (!form.canSearch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select From and To cities')),
      );
      return;
    }

    await form.search();

    if (!context.mounted) return;

    final state = form.state;
    if (state is! AsyncData<BusSearchResponse>) {
      // AsyncError/AsyncOffline are rendered inline below the search button.
      return;
    }
    final response = state.value;

    final trips = response.data?.trips ?? [];
    final filters = response.data?.filters ?? BusFilters.fromTrips(trips);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BusResultsScreen(
          originName: form.originCity!.name,
          destinationName: form.destinationCity!.name,
          journeyDate: form.journeyDate,
          passengerCount: form.passengerCount,
          trips: trips,
          filters: filters,
          searchId: response.searchId,
        ),
      ),
    );
  }
}

/// Swaps origin/destination — matches the flights module's
/// `_SwapCitiesButton` (one_way_round_trip_form.dart) styling.
class _SwapCitiesButton extends StatefulWidget {
  const _SwapCitiesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_SwapCitiesButton> createState() => _SwapCitiesButtonState();
}

class _SwapCitiesButtonState extends State<_SwapCitiesButton> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: CircleBorder(side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.2)),
      elevation: 1.5,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          setState(() => _turns += 0.5);
          widget.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedRotation(
            turns: _turns,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: Icon(Icons.swap_vert, size: 18, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class _CityField extends StatelessWidget {
  const _CityField({
    required this.icon,
    required this.label,
    required this.city,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final BusCity? city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        child: Text(
          city?.fullName ?? 'Select $label',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.date_range, color: Theme.of(context).colorScheme.primary),
          labelText: 'Journey Date',
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        child: Text(DateFormat('EEE, dd MMM yyyy').format(date)),
      ),
    );
  }
}
