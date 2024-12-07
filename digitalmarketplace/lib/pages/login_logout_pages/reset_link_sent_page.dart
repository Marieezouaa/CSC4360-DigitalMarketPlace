import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:digitalmarketplace/pages/login_logout_pages/login_screen.dart';

class ResetLinkSentPage extends StatelessWidget {
  const ResetLinkSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;


    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 84,
                child: Image(
                  image: AssetImage(
                    Theme.of(context).brightness == Brightness.dark
                        ? "assets/images/Dark mode/sunglasses-dark.png"
                        : "assets/images/Light mode/sunglasses-light.png",
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "We sent you an email to reset your password",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 25,
                  color: onSurfaceColor,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(
                    "Return to Login",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: onPrimaryColor,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
