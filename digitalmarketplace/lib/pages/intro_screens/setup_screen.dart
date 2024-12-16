import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String? _usageSelection;
  String? _descriptionSelection;
  String? _artInterestSelection;
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User Usage section
                    Text(
                      "How will you use DoodleBox?",
                      style: GoogleFonts.spicyRice(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Buy", _usageSelection, (value) {
                          setState(() {
                            _usageSelection = value;
                          });
                        }),
                        _optionButton("Sell", _usageSelection, (value) {
                          setState(() {
                            _usageSelection = value;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),


                    Text(
                      "How would you describe yourself?",
                      style: GoogleFonts.spicyRice(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Creator", _descriptionSelection, (value) {
                          setState(() {
                            _descriptionSelection = value;
                          });
                        }),
                        _optionButton("Connoisseur", _descriptionSelection, (value) {
                          setState(() {
                            _descriptionSelection = value;
                          });
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Collector", _descriptionSelection, (value) {
                          setState(() {
                            _descriptionSelection = value;
                          });
                        }),
                        _optionButton("Explorer", _descriptionSelection, (value) {
                          setState(() {
                            _descriptionSelection = value;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),


                    Text(
                      "What type of art are you most interested in?",
                      style: GoogleFonts.spicyRice(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Modern", _artInterestSelection, (value) {
                          setState(() {
                            _artInterestSelection = value;
                          });
                        }),
                        _optionButton("Abstract", _artInterestSelection, (value) {
                          setState(() {
                            _artInterestSelection = value;
                          });
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Traditional", _artInterestSelection, (value) {
                          setState(() {
                            _artInterestSelection = value;
                          });
                        }),
                        _optionButton("Digital", _artInterestSelection, (value) {
                          setState(() {
                            _artInterestSelection = value;
                          });
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Photography", _artInterestSelection, (value) {
                          setState(() {
                            _artInterestSelection = value;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Favorite color scheme section with horizontal scrolling
                    Text(
                      "Choose your favorite color scheme:",
                      style: GoogleFonts.spicyRice(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _colorBox(Colors.red, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.red;
                            });
                          }),
                          _colorBox(Colors.green, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.green;
                            });
                          }),
                          _colorBox(Colors.blue, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.blue;
                            });
                          }),
                          _colorBox(Colors.purple, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.purple;
                            });
                          }),
                          _colorBox(Colors.orange, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.orange;
                            });
                          }),
                          _colorBox(Colors.teal, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.teal;
                            });
                          }),
                          _gradientBox(Colors.pink, Colors.orange, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.pink;
                            });
                          }),
                          _gradientBox(Colors.cyan, Colors.blue, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.cyan;
                            });
                          }),
                          _gradientBox(Colors.lime, Colors.green, _selectedColor, () {
                            setState(() {
                              _selectedColor = Colors.lime;
                            });
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),


                    ElevatedButton(
                      onPressed: () async {

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isSetupComplete', true);


                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text(
                        'Complete Setup',
                        style: GoogleFonts.spicyRice(fontSize: 16),
                      ),
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

  Widget _optionButton(String text, String? selectedValue, Function(String?) onTap) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 160,
          height: 40,
          decoration: BoxDecoration(
            color: selectedValue == text ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.spicyRice(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorBox(Color color, Color? selectedColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: selectedColor == color
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _gradientBox(Color color1, Color color2, Color? selectedColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1, color2]),
            shape: BoxShape.circle,
            border: selectedColor == color1
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
        ),
      ),
    );
  }
}
