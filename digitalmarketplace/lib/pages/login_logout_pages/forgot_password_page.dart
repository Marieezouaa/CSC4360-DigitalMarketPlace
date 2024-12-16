import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digitalmarketplace/pages/login_logout_pages/reset_link_sent_page.dart';
import 'package:digitalmarketplace/models/input_feild.dart';
import 'package:hugeicons/hugeicons.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> passwordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      // Show a dialog if email field is empty
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Please enter an email address."),
          );
        },
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ResetLinkSentPage();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message ?? "An error occurred. Please try again."),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


//colors
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
 
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back when pressed
          },
          child:  Padding(
            padding: const EdgeInsets.all(15.0),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: onSurfaceColor,
              size: 31.0,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Forgot Password",
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: onSurfaceColor,
                  ),
                ),
              ],
            ),

            // Text(
            //   "Enter your Email for link to reset password",
            //   style: GoogleFonts.montserrat(
            //     fontSize: 16, fontWeight: FontWeight.w500),
            // ),
            const SizedBox(height: 10),
            InputFeild(
              controller: _emailController,
              hintTextString: "Enter email here",
              makeTextInvisible: false,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: onPrimaryColor,
                backgroundColor: primaryColor,
              ),
              onPressed: passwordReset,
              child: const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
