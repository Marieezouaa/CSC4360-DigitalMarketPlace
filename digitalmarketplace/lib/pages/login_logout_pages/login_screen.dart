import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:digitalmarketplace/pages/login_logout_pages/create_account.dart';
import 'package:digitalmarketplace/pages/login_logout_pages/forgot_password_page.dart';
import 'package:digitalmarketplace/models/input_feild.dart';
import 'package:digitalmarketplace/service/check_user_setup.dart'; // Import the checkUserSetup function

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // After successful email login, check user setup
      checkUserSetup(context);
    } catch (e) {
      print("Error during email sign-in: $e");
      // Handle error, e.g., show a message
    }
  }

  // Google sign-in
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the login

      final GoogleSignInAuthentication googleAuthentication =
          await googleUser.authentication;

      final userCredential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );

      await _firebaseAuth.signInWithCredential(userCredential);
      // After successful Google login, check user setup
      checkUserSetup(context);
    } catch (e) {
      print("Error during Google sign-in: $e");
      // Handle error, e.g., show a message
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final Color tertiaryColor = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 251, 243, 230),
              Color.fromARGB(255, 181, 87, 145),
            ],
          ),
        ),
        child: Align(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Sign In",
                          style: GoogleFonts.spicyRice(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFeild(
                      controller: emailController,
                      hintTextString: "Email",
                      makeTextInvisible: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFeild(
                      controller: passwordController,
                      hintTextString: "Password",
                      makeTextInvisible: !_isPasswordVisible,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          "Forgot Password? ",
                          style: GoogleFonts.spicyRice(),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Reset Password",
                              style: GoogleFonts.spicyRice(),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: onPrimaryColor,
                        backgroundColor: primaryColor,
                      ),
                      onPressed: signIn,
                      child: Text(
                        "Continue",
                        style: GoogleFonts.spicyRice(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 85,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            'Or Log In with',
                            style: GoogleFonts.spicyRice(
                                color: Color.fromARGB(255, 137, 136, 136)),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 85,
                    ),
                    ElevatedButton(
                      onPressed: signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: onSecondaryColor,
                        backgroundColor: secondaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logos/google_logo.png',
                            height: 24.0,
                          ),
                          const SizedBox(width: 10.0),
                          Text("Sign in with Google",
                              style: GoogleFonts.spicyRice(fontSize: 16.0)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: onSecondaryColor,
                        backgroundColor: secondaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logos/apple_logo.png',
                            height: 24.0,
                          ),
                          const SizedBox(width: 10.0),
                          Text("Sign in with Apple",
                              style: GoogleFonts.spicyRice(fontSize: 16.0)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account yet?",
                              style: GoogleFonts.spicyRice()),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const CreateAccount(),
                                  transitionDuration:
                                      Duration.zero,
                                  reverseTransitionDuration:
                                      Duration.zero,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                            ),
                            child: Text("Create One",
                                style: GoogleFonts.spicyRice()),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
