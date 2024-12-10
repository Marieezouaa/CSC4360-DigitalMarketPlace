import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Add the carousel_slider package

class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final List<String> imagePaths;
  final Color secondaryColor;
  final String collection;

  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.imagePaths,
    required this.secondaryColor,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Product Details screen (you can define this screen later)
      },
      child: Container(
        width: 190,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: imagePaths.isNotEmpty
                    ? Image.network(
                        imagePaths.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(), // Placeholder in case imagePaths is empty
              ),
              // Product Details
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${productPrice}",
                        style: GoogleFonts.gabarito(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
