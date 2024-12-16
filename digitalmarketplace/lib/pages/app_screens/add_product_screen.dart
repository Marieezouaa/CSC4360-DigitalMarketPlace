import 'package:digitalmarketplace/database_helper/artwork_database_helper.dart';
import 'package:digitalmarketplace/database_helper/artwork_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<File> _imageFiles = []; // List to store multiple image files
  final ImagePicker _picker = ImagePicker();
  List<String> _categories = [
    'Painting',
    'Digital Art',
    'Sculpture',
    'Photography',
    'Other'
  ];
  String? _selectedCategory;



 // Firebase and SQLite services
  final ArtworkFirebaseService _firebaseService = ArtworkFirebaseService();
  final ArtworkDatabaseHelper _databaseHelper = ArtworkDatabaseHelper();


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
    if (_imageFiles.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only add up to 5 images.')));
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path)); // Add image to the list
      });
    }
  }

  // Helper method to show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Helper method to reset form
  void _resetForm() {
    setState(() {
      _imageFiles.clear();
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      tags.clear();
      _selectedCategory = null;
    });
  }

  // Mock method to simulate product upload
  Future<void> _uploadArtwork() async {
    // Validate inputs with more detailed error messages
    if (_titleController.text.isEmpty) {
      _showErrorSnackBar('Please enter a title for your artwork');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      _showErrorSnackBar('Please provide a description');
      return;
    }

    if (_imageFiles.isEmpty) {
      _showErrorSnackBar('Please select at least one image');
      return;
    }

    if (_priceController.text.isEmpty) {
      _showErrorSnackBar('Please enter a price');
      return;
    }

    if (_selectedCategory == null) {
      _showErrorSnackBar('Please select a category');
      return;
    }

    try {

      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Create a mock product object
      final mockProduct = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'price': double.parse(_priceController.text),
        'tags': tags,
        'imageCount': _imageFiles.length,
        'uploadTimestamp': DateTime.now().toIso8601String()
      };


      print('Mock Product Created: $mockProduct');

      // Clear the form and show success message
      _resetForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('Error adding product: $e');
      _showErrorSnackBar('Error adding product: ${e.toString()}');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Selection Container
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedAddCircleHalfDot,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Add Image",
                            style: GoogleFonts.spicyRice(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Display selected images in a row
              if (_imageFiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _imageFiles[index],
                              width: 60, 
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

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
                hint: const Text('Select Category'),
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
                decoration: const InputDecoration(
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
                  "Maximum of 5 tags reached.",
                  style: TextStyle(color: Colors.red),
                ),

              // Upload Button
              const SizedBox(height: 20),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: GestureDetector(
                  onTap: _uploadArtwork, // Trigger upload method
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