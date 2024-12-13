import 'package:digitalmarketplace/data/product_images.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalmarketplace/models/images_list.dart';
import 'package:digitalmarketplace/models/product_card.dart';
import 'package:digitalmarketplace/data/product_images.dart'; // Import the images list

class ProductContainerCarousel extends StatefulWidget {
  final String collection;

  const ProductContainerCarousel({super.key, required this.collection});

  @override
  State<ProductContainerCarousel> createState() => _ProductContainerCarouselState();
}

class _ProductContainerCarouselState extends State<ProductContainerCarousel> {
  late final CollectionReference _firebaseCollection =
      FirebaseFirestore.instance.collection(widget.collection);

  // Enhanced method to fetch image paths for a product
  List<String> _getImagePathsForProduct(String productTitle) {
    // Trim and convert to lowercase for more flexible matching
    final normalizedTitle = productTitle.trim().toLowerCase();

    // Find the first matching ImagesList where the product name matches (case-insensitive)
    final matchedItem = images.firstWhere(
      (item) => item.productName.trim().toLowerCase() == normalizedTitle,
      orElse: () => const ImagesList('', []), // Return empty ImagesList if no match
    );

    return matchedItem.images; // Return all images related to the product
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final docs = snapshot.data!.docs.take(4).toList(); // Limit documents to 4
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final productTitle = data['title'] ?? 'Unnamed Product';
                final imagePaths = _getImagePathsForProduct(productTitle);

                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: ProductCard(
                    artwork: data,
                    imagePaths: imagePaths,
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const Center(child: Text('No data found.'));
        }
      },
    );
  }
}