import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 103, 69),
      body: SafeArea(
          child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400, // Provide a specific height
                width: double.infinity, // Use full width
                child: PDFView(
                  filePath: 'assets/images/onboarding_images/secondscreen.pdf',
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
