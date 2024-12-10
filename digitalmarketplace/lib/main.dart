import 'package:digitalmarketplace/pages/intro_screens/setup_screen.dart';
import 'package:digitalmarketplace/pages/intro_screens/gather_user_details.dart';
import 'package:digitalmarketplace/pages/onboarding_pages/onboarding_page.dart';
import 'package:digitalmarketplace/util/nav_bar.dart'; // Import the NavBar
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digitalmarketplace/styles/color_themes.dart';
import 'package:digitalmarketplace/pages/login_logout_pages/login_screen.dart';
import 'package:digitalmarketplace/pages/login_logout_pages/create_account.dart';
import 'package:digitalmarketplace/pages/app_screens/home_screen.dart'; // Your HomeScreen
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartupScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/setup': (context) => const SetupScreen(),
        '/createAccount': (context) => const CreateAccount(),
      },
    );
  }
}

/// StartupScreen determines if the user should see onboarding, login, or home.
class StartupScreen extends StatelessWidget {
  const StartupScreen({Key? key}) : super(key: key);

  Future<bool> _hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSeenOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error loading app. Please try again later.'),
            ),
          );
        }

        final hasSeenOnboarding = snapshot.data ?? false;

        if (!hasSeenOnboarding) {
          return const OnboardingPage();
        } else {
          return const AuthWrapper(); // Check for auth status
        }
      },
    );
  }
}

/// AuthWrapper dynamically routes the user based on authentication status
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong. Please try again later.'),
            ),
          );
        } else if (snapshot.hasData) {
          // User is authenticated
          // Return the HomeScreen that includes NavBar
          return const HomeScreen();
        } else {
          // User is not authenticated
          return const LoginScreen();
        }
      },
    );
  }
}

/// HomeScreen with NavBar (Custom Navigation)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to the Home Screen!'),
            // Add more content as needed
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(), // Your custom NavBar
    );
  }
}
