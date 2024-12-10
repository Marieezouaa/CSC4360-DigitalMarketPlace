import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
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
                        _optionButton("Buy"),
                        _optionButton("Sell"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Description section
                    Text(
                      "How would you describe yourself?",
                      style: GoogleFonts.spicyRice(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Creator"),
                        _optionButton("Connoisseur"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Collector"),
                        _optionButton("Explorer"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Art interest section
                    Text(
                      "What type of art are you most interested in?",
                      style: GoogleFonts.spicyRice(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Modern"),
                        _optionButton("Abstract"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Traditional"),
                        _optionButton("Digital"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _optionButton("Photography"),
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
                          _colorBox(Colors.red),
                          _colorBox(Colors.green),
                          _colorBox(Colors.blue),
                          _colorBox(Colors.purple),
                          _colorBox(Colors.orange),
                          _colorBox(Colors.teal),
                          _gradientBox(Colors.pink, Colors.orange),
                          _gradientBox(Colors.cyan, Colors.blue),
                          _gradientBox(Colors.lime, Colors.green),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Completed Button
                    ElevatedButton(
                      onPressed: () async {
                        // Mark the setup as complete in SharedPreferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isSetupComplete', true);

                        // Navigate to the home screen or the desired screen after setup
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

  Widget _optionButton(String text) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 160,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
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

  Widget _colorBox(Color color) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _gradientBox(Color color1, Color color2) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1, color2]),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
