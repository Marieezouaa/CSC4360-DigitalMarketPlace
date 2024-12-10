import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';

class GatherUserDetails extends StatefulWidget {
  const GatherUserDetails({Key? key}) : super(key: key);

  @override
  State<GatherUserDetails> createState() => _GatherUserDetailsState();
}

class _GatherUserDetailsState extends State<GatherUserDetails> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _bio = '';
  String _phoneNumber = '';
  List<String> _portfolio = [];
  String _role = 'Not Sure Yet';
  String _countryCode = '+1'; // Default country code (can be changed to another default)

  // Function to save user details to Firestore
  Future<void> _saveUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not authenticated (show error message or redirect to login)
      print("User is not logged in");
      return;
    }

    final userId = user.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userName': _userName,
      'bio': _bio,
      'phoneNumber': _phoneNumber,
      'portfolio': _portfolio,
      'role': _role,
      'countryCode': _countryCode, // Save country code
    });

    // Optionally, navigate to the next screen after saving the details
    Navigator.pushReplacementNamed(context, '/home');
  }

  // Function to show country picker
  void _selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // Show phone code
      onSelect: (Country country) {
        setState(() {
          _countryCode = country.phoneCode;
        });
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional height for the country list modal
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

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
                child: Form(  // Wrap the entire form in the Form widget
                  key: _formKey,  // Reference the form key
                  child: Column(
                    children: [
                      // Title
                      Text(
                        "Personal Details",
                        style: GoogleFonts.spicyRice(fontSize: 24),
                      ),
                      const SizedBox(height: 20),

                      // User Name
                      _buildTextFormField('User Name', (value) => _userName = value ?? '', 'Please enter your username'),

                      // Bio
                      _buildTextFormField('Bio', (value) => _bio = value ?? '', 'Please enter your bio'),

                      // Phone Number with Country Picker
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            // Country Code Button
                            ElevatedButton(
                              onPressed: () => _selectCountry(context),
                              child: Text(
                                _countryCode,
                                style: GoogleFonts.spicyRice(fontSize: 16, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Phone Number Field
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: GoogleFonts.spicyRice(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onSaved: (value) => _phoneNumber = value ?? '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Portfolio URLs
                      _buildTextFormField('Portfolio URL', (value) {
                        if (value != null && value.isNotEmpty) {
                          _portfolio.add(value);
                        }
                      }, null),

                      const SizedBox(height: 20),

                      // Role Dropdown
                      DropdownButtonFormField<String>(
                        value: _role,
                        items: ['Buyer', 'Seller', 'Both', 'Not Sure Yet']
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role, style: GoogleFonts.spicyRice(fontSize: 16)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _role = value ?? 'Not Sure Yet';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Role',
                          labelStyle: GoogleFonts.spicyRice(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save Button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            _saveUserDetails();
                          }
                        },
                        child: Text(
                          'Save Details',
                          style: GoogleFonts.spicyRice(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String?)? onSaved, String? validatorMessage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.spicyRice(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSaved: onSaved,
        validator: validatorMessage != null ? (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        } : null,
      ),
    );
  }
}
