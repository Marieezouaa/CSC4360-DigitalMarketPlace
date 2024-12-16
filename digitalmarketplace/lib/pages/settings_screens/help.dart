import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: GoogleFonts.spicyRice(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FAQs',
              style: GoogleFonts.spicyRice(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '1. How do I link my debit card?\n   - Go to the Wallet screen and tap on the "Link Debit Card" button.',
              style: GoogleFonts.spicyRice(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              '2. How can I track my orders?\n   - Visit the Orders screen to see your order history.',
              style: GoogleFonts.spicyRice(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Need further assistance?',
              style: GoogleFonts.spicyRice(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Contact our support team at support@doodlebox.com.',
              style: GoogleFonts.spicyRice(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
