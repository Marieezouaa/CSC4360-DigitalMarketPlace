import 'package:digitalmarketplace/models/settings_containers.dart';
import 'package:digitalmarketplace/pages/app_screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    final Color errorColor = Theme.of(context).colorScheme.error;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 13, bottom: 2, left: 10, right: 10),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/profile/profile_pic.png"))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 25, left: 10, right: 10),
                  child: Container(
                    width: 385,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: secondaryColor,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 4, left: 10, right: 8),
                            child: Text(
                              "User's Name",
                              style: GoogleFonts.gabarito(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w500,
                                  color: onSecondaryColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, bottom: 8, left: 10, right: 8),
                                  child: Text(
                                    "The user's address",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 149, 149, 149)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 2, top: 2, bottom: 2),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text("Edit",
                                      style: GoogleFonts.gabarito(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 8, left: 10, right: 8),
                            child: Text(
                              "123-456-7890",
                              style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 149, 149, 149)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SettingsContainers(
                  navigateTo: HomeScreen(),
                  sectionTitle: "Address",
                ),
                const SettingsContainers(
                  navigateTo: HomeScreen(),
                  sectionTitle: "Wishlist",
                ),
                const SettingsContainers(
                  navigateTo: HomeScreen(),
                  sectionTitle: "Payment",
                ),
                const SettingsContainers(
                  navigateTo: HomeScreen(),
                  sectionTitle: "Help",
                ),
                const SizedBox(height: 20), // Added SizedBox for spacing
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      // Navigate to the login screen after sign out
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 26.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Signout",
                              style: GoogleFonts.montserrat(
                                  color: errorColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedLogout03,
                              color: errorColor,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
