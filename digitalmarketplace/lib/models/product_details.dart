import 'package:flutter/material.dart';
// ProductDetails widget
class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> artwork;

  const ProductDetails({required this.artwork, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(artwork['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              _getAssetImageForArtwork(artwork['category']),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            Text(
              artwork['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: \$${artwork['price'].toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artwork['description'],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Category: ${artwork['category']}",
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Created at: ${artwork['createdAt']}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _getAssetImageForArtwork(String category) {
    // Same logic as in ProductCard
    switch (category) {
      case 'painting':
        return 'assets/images/painting.png';
      case 'sculpture':
        return 'assets/images/sculpture.png';
      case 'photography':
        return 'assets/images/photography.png';
      default:
        return 'assets/images/placeholder.png';
    }
  }
}
