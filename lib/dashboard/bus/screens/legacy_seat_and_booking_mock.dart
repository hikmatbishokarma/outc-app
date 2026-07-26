import 'package:flutter/material.dart';
import 'package:outc/widgets/colors/colors.dart';

// Moved verbatim out of the old BusDashboard.dart (spec 0006's Out of Scope:
// "today's mock implementations... are left as-is and untouched by this
// spec"). Currently unreferenced — kept only so a future seat-selection/
// booking-flow spec has them to build on, same as this repo's other known
// legacy files (see CLAUDE.md "Known legacy/dead files").

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<String> selectedSeats = [];

  final List<Map<String, dynamic>> lowerDeck = [
    {"id": "L1", "price": 2280.0, "status": "available"},
    {"id": "L2", "price": 1580.0, "status": "sold"},
    {"id": "L3", "price": 1580.0, "status": "male"},
    {"id": "L4", "price": 1580.0, "status": "female"},
    {"id": "L5", "price": 1580.0, "status": "available"},
    {"id": "L6", "price": 1580.0, "status": "available"},
    {"id": "L7", "price": 1580.0, "status": "sold"},
    {"id": "L8", "price": 2280.0, "status": "available"},
    {"id": "L9", "price": 1580.0, "status": "available"},
  ];

  final List<Map<String, dynamic>> upperDeck = [
    {"id": "U1", "price": 1980.0, "status": "available"},
    {"id": "U2", "price": 1380.0, "status": "male"},
    {"id": "U3", "price": 1380.0, "status": "sold"},
    {"id": "U4", "price": 1980.0, "status": "selected"},
    {"id": "U5", "price": 1080.0, "status": "male"},
    {"id": "U6", "price": 1380.0, "status": "female"},
    {"id": "U7", "price": 1980.0, "status": "available"},
    {"id": "U8", "price": 1380.0, "status": "available"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Select Seats"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildDeck(
                title: "Lower deck",
                icon: Icons.directions_bus_filled,
                seats: lowerDeck,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDeck(
                title: "Upper deck",
                seats: upperDeck,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: selectedSeats.isEmpty
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        selectedSeats: selectedSeats,
                        totalFare: _calculateTotalFare(),
                      ),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colours.orangeOutC,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            selectedSeats.isEmpty
                ? "Select seats to continue"
                : "Continue (${selectedSeats.length} seats)",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDeck({
    required String title,
    IconData? icon,
    required List<Map<String, dynamic>> seats,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              if (icon != null) Icon(Icons.star, size: 24, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: seats.length,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final seat = seats[index];
                final status = seat["status"] as String;
                final id = seat["id"] as String;
                final isSelected = selectedSeats.contains(id);

                return _buildSeatTile(
                  id: id,
                  price: seat["price"],
                  status: isSelected ? "selected" : status,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatTile({
    required String id,
    required double price,
    required String status,
  }) {
    Color borderColor = Colors.green;
    Color fillColor = Colors.white;
    Widget? overlay;
    IconData? genderIcon;

    switch (status) {
      case "available":
        borderColor = Colors.green;
        break;
      case "selected":
        borderColor = Colors.green.shade800;
        fillColor = Colors.green.shade600;
        break;
      case "sold":
        fillColor = Colors.grey.shade300;
        borderColor = Colors.grey.shade300;
        overlay = const Text(
          "Sold",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        );
        break;
      case "male":
        borderColor = Colors.blue;
        genderIcon = Icons.male;
        break;
      case "female":
        borderColor = Colors.pinkAccent;
        genderIcon = Icons.female;
        break;
    }

    return GestureDetector(
      onTap: status == "sold"
          ? null
          : () {
              setState(() {
                if (selectedSeats.contains(id)) {
                  selectedSeats.remove(id);
                } else {
                  selectedSeats.add(id);
                }
              });
            },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 70,
                width: 45,
                decoration: BoxDecoration(
                  color: fillColor,
                  border: Border.all(color: borderColor, width: 1.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 6,
                      width: 25,
                      decoration: BoxDecoration(
                        color:
                            status == "selected" ? Colors.white70 : borderColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              if (genderIcon != null)
                Icon(genderIcon, color: borderColor, size: 18),
              if (overlay != null) overlay,
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "₹${price.toInt()}",
            style: TextStyle(
              color: status == "sold" ? Colors.grey : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalFare() {
    double total = 0.0;

    for (var seat in lowerDeck) {
      if (selectedSeats.contains(seat["id"])) {
        total += seat["price"];
      }
    }

    for (var seat in upperDeck) {
      if (selectedSeats.contains(seat["id"])) {
        total += seat["price"];
      }
    }

    return total;
  }
}

class BookingScreen extends StatefulWidget {
  final List<String> selectedSeats;
  final double totalFare;

  const BookingScreen({
    super.key,
    required this.selectedSeats,
    required this.totalFare,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedBoarding;
  String? selectedDropping;

  // Sample boarding/dropping points
  final List<Map<String, String>> boardingPoints = [
    {"time": "20:31", "name": "Prakashnagar Metro Pick up"},
    {"time": "20:50", "name": "Yusufguda Metro Pick up"},
    {"time": "21:10", "name": "Kukatpally Metro Police Station"},
    {"time": "21:27", "name": "JNTU"},
  ];

  final List<Map<String, String>> droppingPoints = [
    {"time": "06:30", "name": "Devanahalli"},
    {"time": "07:00", "name": "Chikkaballapur Bypass"},
    {"time": "07:25", "name": "BIAL Airport"},
  ];

  // Passenger details controllers
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> ageControllers;
  List<String> genders = [];

  bool freeCancellation = false;
  bool assurance = false;
  bool donate = false;

  @override
  void initState() {
    super.initState();
    nameControllers = List.generate(
        widget.selectedSeats.length, (_) => TextEditingController());
    ageControllers = List.generate(
        widget.selectedSeats.length, (_) => TextEditingController());
    genders = List.generate(widget.selectedSeats.length, (_) => "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fareSummarySection(),
            const SizedBox(height: 16),
            _boardingDroppingSection(),
            const SizedBox(height: 16),
            _contactSection(),
            const SizedBox(height: 16),
            _passengerDetailsSection(),
            const SizedBox(height: 16),
            _addOnsSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _fareSummarySection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Selected Seats: ${widget.selectedSeats.join(', ')}\nTotal Fare: ₹${widget.totalFare.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colours.orangeOutC,
            ),
            child: const Text(
              "Select Boarding/Dropping",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _boardingDroppingSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _pointList(
            "Boarding Points",
            boardingPoints,
            selectedBoarding,
            (val) => setState(() => selectedBoarding = val),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _pointList(
            "Dropping Points",
            droppingPoints,
            selectedDropping,
            (val) => setState(() => selectedDropping = val),
          ),
        ),
      ],
    );
  }

  Widget _pointList(
    String title,
    List<Map<String, String>> points,
    String? selected,
    Function(String) onSelect,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          ...points.map((p) {
            return RadioListTile<String>(
              value: p["name"]!,
              groupValue: selected,
              onChanged: (val) => onSelect(val!),
              title: Text(p["name"]!),
              subtitle: Text("${p["time"]}  •  Avail Free Metro Pickup"),
            );
          }),
        ],
      ),
    );
  }

  Widget _contactSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Contact Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          TextField(decoration: _input("Phone")),
          const SizedBox(height: 10),
          TextField(decoration: _input("Email ID")),
          const SizedBox(height: 10),
          TextField(decoration: _input("State of Residence")),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (v) {},
              ),
              const Text("Send booking details via WhatsApp"),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _passengerDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Passenger Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        ...List.generate(widget.selectedSeats.length, (i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Passenger ${i + 1}  •  Seat ${widget.selectedSeats[i]}"),
                const SizedBox(height: 8),
                TextField(
                    controller: nameControllers[i], decoration: _input("Name")),
                const SizedBox(height: 8),
                TextField(
                    controller: ageControllers[i], decoration: _input("Age")),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Male"),
                        value: "Male",
                        groupValue: genders[i],
                        onChanged: (val) => setState(() => genders[i] = val!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Female"),
                        value: "Female",
                        groupValue: genders[i],
                        onChanged: (val) => setState(() => genders[i] = val!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _addOnsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Add-Ons",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text("Add Free Cancellation (₹250/passenger)"),
          value: freeCancellation,
          onChanged: (v) => setState(() => freeCancellation = v),
        ),
        SwitchListTile(
          title: const Text("Add redBus Assurance (₹62/passenger)"),
          value: assurance,
          onChanged: (v) => setState(() => assurance = v),
        ),
        SwitchListTile(
          title: const Text("Donate ₹5 to RedBus Cares"),
          value: donate,
          onChanged: (v) => setState(() => donate = v),
        ),
      ],
    );
  }

  Widget _bottomBar() {
    final double finalAmount = widget.totalFare +
        (freeCancellation ? 250 * widget.selectedSeats.length : 0) +
        (assurance ? 62 * widget.selectedSeats.length : 0) +
        (donate ? 5 : 0);

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Total: ₹${finalAmount.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colours.orangeOutC,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              "Complete Payment",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
