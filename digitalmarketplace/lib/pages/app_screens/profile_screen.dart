import 'package:cloud_firestore/cloud_firestore.dart';
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
  String userName = "";
  String phoneNumber = "Add Number +";
  String address = "Add Address +";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          userName = data['userName'] ?? "";
          phoneNumber = data['phoneNumber']?.isNotEmpty == true
              ? data['phoneNumber']
              : "Add Number +";
          address = data['address']?.isNotEmpty == true
              ? data['address']
              : "Add Address +";
        });
      }
    }
  }

  void navigateToEditScreen(String field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldScreen(field: field),
      ),
    ).then((_) => fetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    final Color errorColor = Theme.of(context).colorScheme.error;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50.0, bottom: 0, left: 8, right: 8),
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
                            image: AssetImage(
                                "assets/images/profile/profile_pic.png"))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 10, left: 10, right: 10),
                  child: Container(
                    width: 385,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 190, 169, 227),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 4, left: 10, right: 8),
                            child: Text(
                              userName.isNotEmpty ? userName : "Loading...",
                              style: GoogleFonts.gabarito(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
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
                                child: GestureDetector(
                                  onTap: () => navigateToEditScreen("address"),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 8, left: 10, right: 8),
                                    child: Text(
                                      address,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
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
                          child: GestureDetector(
                            onTap: () => navigateToEditScreen("phoneNumber"),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 8, left: 10, right: 8),
                              child: Text(
                                phoneNumber,
                                style: GoogleFonts.montserrat(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Container(
                    height: 350,
                    child: const SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SettingsContainers(
                            navigateTo: HomeScreen(),
                            sectionTitle: "Orders",
                          ),
                          SettingsContainers(
                            navigateTo: HomeScreen(),
                            sectionTitle: "Favorites",
                          ),
                          SettingsContainers(
                            navigateTo: HomeScreen(),
                            sectionTitle: "Wishlist",
                          ),
                          SettingsContainers(
                            navigateTo: HomeScreen(),
                            sectionTitle: "Wallet",
                          ),
                          SettingsContainers(
                            navigateTo: HomeScreen(),
                            sectionTitle: "Help",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12), // Added SizedBox for spacing
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

class EditFieldScreen extends StatelessWidget {
  final String field;

  const EditFieldScreen({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${field.capitalize()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter your ${field.capitalize()}",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({field: controller.text.trim()});
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
