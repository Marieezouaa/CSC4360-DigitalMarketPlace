import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// UI and Utility Imports
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

// Dart Imports
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final int maxDescriptionCharacters = 150;
  final int maxTitleCharacters = 70;
  final int maxTags = 5;

  List<String> tags = [];
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  User? _currentUser;
  List<String> _categories = [
    'Painting',
    'Digital Art',
    'Sculpture',
    'Photography',
    'Other'
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  void _fetchCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user signed in. Please log in.')));
    }
  }

  void _addTag(String tag) {
    if (tags.length < maxTags && tag.isNotEmpty && !tags.contains(tag)) {
      setState(() {
        tags.add(tag);
      });
    }
    _tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadArtwork() async {
    // Validate inputs
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to upload artwork')));
      return;
    }

    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _imageFile == null ||
        _priceController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields and select an image')));
      return;
    }

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
          'artworks/${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      // Create artwork document in Firestore
      final artworkRef =
          FirebaseFirestore.instance.collection('artworks').doc();

      await artworkRef.set({
        'artistId': _currentUser!.uid,
        'artworkId': artworkRef.id,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageUrl': imageUrl,
        'category': _selectedCategory,
        'tags': tags,
        'price': double.parse(_priceController.text),
        'salePrice': 0,
        'currency': 'USD',
        'isAvailable': true,
        'isOnSale': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear the form and show success message
      setState(() {
        _imageFile = null;
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        tags.clear();
        _selectedCategory = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artwork uploaded successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading artwork: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 80, bottom: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Selection
                GestureDetector(
                  onTap: _pickImage,
                  child: DottedBorder(
                    strokeWidth: 2,
                    color: const Color.fromARGB(255, 136, 136, 136),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [5, 5],
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      color: const Color.fromARGB(255, 233, 231, 231),
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const HugeIcon(
                                    icon:
                                        HugeIcons.strokeRoundedAddCircleHalfDot,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Add Image",
                                    style: GoogleFonts.spicyRice(),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Title Input
                Text("Title", style: GoogleFonts.spicyRice(fontSize: 16)),
                const SizedBox(height: 5),
                TextField(
                  controller: _titleController,
                  maxLength: maxTitleCharacters,
                  decoration: InputDecoration(
                    hintText: "What are you selling?",
                    counterText:
                        "${maxTitleCharacters - _titleController.text.length} characters remaining",
                  ),
                ),

                // Description Input
                const SizedBox(height: 15),
                Text("Description", style: GoogleFonts.spicyRice()),
                const SizedBox(height: 5),
                TextField(
                  controller: _descriptionController,
                  maxLength: maxDescriptionCharacters,
                  decoration: InputDecoration(
                    hintText: "Enter description here...",
                    counterText:
                        "${maxDescriptionCharacters - _descriptionController.text.length} characters remaining",
                  ),
                  maxLines: 3,
                ),

                // Category Dropdown
                const SizedBox(height: 15),
                Text("Category", style: GoogleFonts.spicyRice()),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text('Select Category'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                // Price Input
                const SizedBox(height: 15),
                Text("Price", style: GoogleFonts.spicyRice()),
                const SizedBox(height: 5),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  decoration: const InputDecoration(
                    hintText: "Enter price",
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),

                // Tags Input
                const SizedBox(height: 15),
                Text("Tags", style: GoogleFonts.spicyRice()),
                const SizedBox(height: 5),
                TextField(
                  controller: _tagController,
                  decoration: InputDecoration(
                    hintText: "Enter a hashtag",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _addTag(_tagController.text.trim());
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    _addTag(value.trim());
                  },
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _removeTag(tag),
                    );
                  }).toList(),
                ),
                if (tags.length >= maxTags)
                  const Text(
                    "Maximum of 5 tags allowed",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),

                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 320,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 122, 42, 202),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Add Product",
                          style: GoogleFonts.spicyRice(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 320,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 112, 109, 115),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Save Draft",
                          style: GoogleFonts.spicyRice(color: Colors.white),
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

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    _tagController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
