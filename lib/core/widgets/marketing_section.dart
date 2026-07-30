import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// The promotional/marketing content ("Best Price Guaranteed", "24*7
/// Support", destination images, "Why OutC?") shown below Flights' search
/// form and on the Home tab — generic app-wide content, not flights-specific,
/// so it lives in `lib/core/` per `docs/architecture.md` §1 rather than
/// being cross-imported from the flights module. Extracted verbatim out of
/// the old `search_flights.dart` monolith, not restyled.
class MarketingSection extends StatelessWidget {
  const MarketingSection({super.key});

  static const String _whyOutc1 =
      "Our competitive rates and exclusive offers are what gives us a top notch over our competitors. We promise 'Unbeatable' services both in pricing and quality. Here is the one stop destination for your Dream Destination. OutC provide you the best travel packages at the lowest possible pricing that gives the best value for your each penny. We are your Travel Companion and works for you so that can get the best travel experience and live some memorable moments.";

  static const String _whyOutc2 =
      "We give you the pros and cons for all the different travel products and allow you to decide what works best for you and your family. We combine first-hand knowledge with exceptional special offers, and we take care of every detail to create a holiday as unique as you are. You will no more need to worry about coordinating flight bookings, hotel reservations, visa stamps or tours as all your needs are taken care of under one roof.";

  static const String _whyOutc3 =
      "OutC can satisfy all your travel needs. Here, You can book flight tickets, hotels, bus tickets, activities and holiday packages at a cost-effective price. So, why go anywhere else? Visit us for a memorable travel experience in your budget.";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: Column(
            children: [
              Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade400)),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Column(children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.privacy_tip_sharp, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BEST PRICE GUARANTED",
                                    style: GoogleFonts.poppins(
                                        color: AppColors.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                      width: 300,
                                      child: Text(
                                        "Trying Our level best to fetch lower price than others, try us once!!",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ],
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ]))),
              const SizedBox(height: 5),
              Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade400)),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Column(children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.av_timer, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "24*7 SUPPORT",
                                    style: GoogleFonts.poppins(
                                        color: AppColors.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                      width: 300,
                                      child: Text(
                                        "We're always here for you - reach us 24 hours a day ,7 days a week",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ],
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ]))),
              const SizedBox(height: 20),
              Container(
                height: 250,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const _NetworkImage(
                    "https://i.insider.com/5d38ca7d36e03c5dfa2ed4e3?width=750&format=jpeg&auto=webp",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 250,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // This particular URL 404s (dead link, not something this
                  // migration broke) — `_NetworkImage` hides it instead of
                  // showing Flutter's default red-X error placeholder.
                  child: const _NetworkImage(
                    "https://www.indus.travel/aviator/qstvsndfvb/uploads/2018/07/most-visited-places-India-by-foreign-tourists.jpg",
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Travel for less with our great deals",
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Why OutC ?",
                  style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Divider(
                  color: Colors.grey.shade600,
                  indent: 150,
                  endIndent: 160,
                  thickness: 2.0,
                  height: 1.5,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            children: [
              Text(_whyOutc1,
                  style:
                      GoogleFonts.poppins(color: Colors.black, fontSize: 12)),
              Text(_whyOutc2,
                  style:
                      GoogleFonts.poppins(color: Colors.black, fontSize: 12)),
              Text(_whyOutc3,
                  style:
                      GoogleFonts.poppins(color: Colors.black, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

/// `Image.network` with a graceful fallback — a dead/404 URL collapses to an
/// empty box instead of Flutter's default red-X error placeholder.
class _NetworkImage extends StatelessWidget {
  const _NetworkImage(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
