import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Emenities extends StatefulWidget {
  const Emenities({super.key});

  @override
  State<Emenities> createState() => _EmenitiesState();
}

class _EmenitiesState extends State<Emenities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Hotel Facilites',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Gift shops or newstand',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Dry cleaning /laundary service',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'shopping on site',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Train Station (Pick Up)',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Gated Community',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Pool Umbrellas',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Swimming Pool',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text(
                  'Free Wfi',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
