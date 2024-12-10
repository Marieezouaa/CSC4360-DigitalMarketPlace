import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingBanner extends StatelessWidget {
  final String title;

  const TrendingBanner({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390, // Width similar to the original version
      height: 120, // Height from the original version
      decoration: BoxDecoration(
        color: Colors.grey[200], // Softer grey background (like in the first version)
        borderRadius: BorderRadius.circular(30), // Larger border radius for soft edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Softer shadow
            spreadRadius: 1,
            blurRadius: 8, // Light blur effect
            offset: const Offset(0, 4), // Slight offset for depth
          ),
        ],
      ),
      padding: const EdgeInsets.all(16), // Padding for the title
      child: Align(
        alignment: Alignment.bottomLeft, // Align the title to the bottom left
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8), // Decreased padding to move title closer to the bottom
          child: Text(
            title,
            style: GoogleFonts.spicyRice( // Using GoogleFonts like in the first version
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
