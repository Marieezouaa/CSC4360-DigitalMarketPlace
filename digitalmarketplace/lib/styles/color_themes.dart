import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static const Color discountGreen = Color(0xff5FB567);

  static final TextStyle gabaritoFont = GoogleFonts.gabarito();

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        colorScheme: colorScheme,
        highlightColor: Colors.transparent,
        focusColor: focusColor);
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    /*
     White: Color(0xffFFFFFF)
    Black: Color(0xff000000)
    */
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF000000),

    /*
     Light Brown: Color(0xffD6A97A)
    White: Color(0xffFFFFFF)
    */
    primary: Color(0xffD6A97A), //background color
    onPrimary: Colors.white,

    /*
    Smokey White: Color(0xffF4F4F4)
    Black: Color(0xff000000)
    */
    secondary: Color.fromARGB(255, 235, 235, 235),
    onSecondary: Color(0xff000000),

    /*
    Light Brown: Color(0xffD6A97A)
    White: Color(0xffFFFFFF)
    */
    tertiary:  Color.fromARGB(255, 175, 126, 70),
    onTertiary: Colors.white,

    /*
    Red: Color(0xffFA3636)
    White: Color(0xffFFFFFF)
    */
    error: Color(0xffFA3636),
    onError: Colors.white,

    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    /*
    Dark Purple: Color(0xff1D182A)
    White: Color(0xffFFFFFF)
    */
    surface: Color(0xff1D182A), //background color
    onSurface: Colors.white,

    /*
    Light Purple: Color(0xff8E6CEF)
    White: Color(0xffFFFFFF)
    */
    primary: Color(0xff8E6CEF), //accent color
    onPrimary: Colors.white,

    /*
    Smokey Purple: Color(0xff342F3F)
    White: Color(0xffFFFFFF)
    */
    secondary: Color.fromARGB(255, 64, 57, 78), //for containers
    onSecondary: Colors.white,

    /*
    Light Brown: Color(0xffD6A97A)
    White: Color(0xffFFFFFF)
    */
    tertiary:Color.fromARGB(255, 175, 126, 70),
    onTertiary: Colors.white,

    /*
    Red: Color(0xffFA3636)
    White: Color(0xffFFFFFF)
    */
    error: Color(0xffFA3636),
    onError: Colors.white,

    brightness: Brightness.dark,
  );
}
