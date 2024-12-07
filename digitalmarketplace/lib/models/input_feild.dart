import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class InputFeild extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String? hintTextString;
  bool makeTextInvisible;

  InputFeild(
      {super.key,
      required this.controller,
      required this.hintTextString,
      required this.makeTextInvisible});

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    return TextField(
      controller: controller,
      obscureText: makeTextInvisible,
      decoration: InputDecoration(
        filled: true, // Fills the background with a color
        fillColor: secondaryColor, // Light grey background color
        hintText: hintTextString,
        hintStyle: GoogleFonts.montserrat(
          color: onSecondaryColor,
          fontSize: 16,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)), // Rounded corners
          borderSide: BorderSide.none, // No visible border line
        ),
      ),
    );
  }
}
