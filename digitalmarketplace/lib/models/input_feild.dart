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
        filled: true,
        fillColor: Color.fromARGB(255, 244, 244, 244),
        hintText: hintTextString,
        hintStyle: GoogleFonts.spicyRice(
          color: Colors.black,
          fontSize: 16,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide.none, 
        ),
      ),
    );
  }
}
