import 'package:digitalmarketplace/pages/intro_screens/setup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:digitalmarketplace/pages/login_logout_pages/login_screen.dart';
import 'package:digitalmarketplace/models/input_feild.dart';
import 'package:email_validator/email_validator.dart';
import 'package:digitalmarketplace/pages/app_screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() {
    return _CreateAccountState();
  }
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;

  bool _isValid = false;
  String _errorMessage = '';

  // Password validation function
  bool _validateCredentials(String password, String email) {
    _errorMessage = '';

    bool isValidEmail = EmailValidator.validate(email);
    if (!isValidEmail) {
      _errorMessage += "Email is not valid.";
    }

    if (password.length < 6) {
      _errorMessage += 'Password must be longer than 6 characters.\n';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
    }
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _errorMessage += '• Special character is missing.\n';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );

    return _errorMessage.isEmpty;
  }

Future<void> signUpWithGoogle() async {
  // Start the Google sign-in process
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // If the user cancels the sign-in, return early
  if (googleUser == null) return;

  // Authenticate the Google sign-in
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new Firebase credential with Google sign-in tokens
  //code by marieezouaa
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Sign in to Firebase with the Google credential
  final UserCredential userCredential = 
      await _firebaseAuth.signInWithCredential(credential);

  // Check if this is a new user by inspecting the `additionalUserInfo` property
  if (userCredential.additionalUserInfo?.isNewUser ?? false) {
    // Perform any additional setup for a new user
    await _initializeNewUser(userCredential.user);
  }
}

Future<void> _initializeNewUser(User? user) async {
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'bio': '', // Default empty string
      'country': '', // Default empty string
      'email': user.email ?? '',
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'phoneNumber': '', // Default empty string
      'portfolio': [], // Empty array
      'purchaseHistory': [], // Empty array
      'role': 'user', // Default role
      'userId': user.uid,
      'userName': '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
    });
  }
}

Future<void> signUp() async {
  // Ensure passwords match
  if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  try {
    // Create user with email and password
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Initialize new user data
    await _initializeNewUser(userCredential.user);

    // Display success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created successfully!")),
    );

    // Navigate to the SetupScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SetupScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    if (e.code == 'weak-password') {
      errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'The account already exists for that email.';
    } else {
      errorMessage = 'An unknown error occurred. Please try again.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Failed to create account. Please try again.")),
    );
  }
}


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
      backgroundColor: surfaceColor,
      body: Align(
        child: Container(
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
                        "Create Account",
                        style: GoogleFonts.spicyRice(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: onSurfaceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 180,
                        child: InputFeild(
                          controller: firstNameController,
                          hintTextString: "First Name",
                          makeTextInvisible: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 200,
                        child: InputFeild(
                          controller: lastNameController,
                          hintTextString: "Last Name",
                          makeTextInvisible: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputFeild(
                    controller: emailController,
                    hintTextString: "Email",
                    makeTextInvisible: false,
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      InputFeild(
                        controller: passwordController,
                        hintTextString: "Password",
                        makeTextInvisible: !_isPasswordVisible,
                      ),
                      IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: tertiaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputFeild(
                    controller: confirmPasswordController,
                    hintTextString: "Confirm Password",
                    makeTextInvisible: !_isPasswordVisible,
                  ),
                  const SizedBox(height: 55),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: onPrimaryColor,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isValid = _validateCredentials(
                            passwordController.text, emailController.text);
                      });
                      if (_isValid) {
                        signUp();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_errorMessage)));
                      }
                    },
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.spicyRice(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //code by marieezouaa
                      const Expanded(
                        child: Divider(color: Color.fromARGB(255, 48, 48, 48), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Or Sign Up with',
                        style: GoogleFonts.spicyRice(
                              color: Color.fromARGB(255, 48, 48, 48),),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color.fromARGB(255, 48, 48, 48), thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signUpWithGoogle,
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
                     Text("Sign up with Google",
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
                          vertical: 12.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ), //code by marieezouaa
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logos/apple_logo.png',
                          height: 24.0,
                        ),
                        const SizedBox(width: 10.0),
                         Text("Sign up with Apple",
                           style: GoogleFonts.spicyRice(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text("Already have an account?",  style: GoogleFonts.spicyRice(),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                          ),
                          child: Text("Login", style: GoogleFonts.spicyRice()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
