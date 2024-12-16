import 'package:digitalmarketplace/models/product_details.dart';
import 'package:digitalmarketplace/pages/settings_screens/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> artwork;
  final List<String> imagePaths;

  const ProductCard({
    required this.artwork,
    required this.imagePaths,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorited = favoritesProvider.isFavorite(artwork);

        return GestureDetector(
          onTap: () {
            // Handle navigation to product details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetails(artwork: artwork),
              ),
            );
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
                  // Carousel for local images
                  Positioned.fill(
                    child: imagePaths.isNotEmpty
                        ? Image.asset(
                            imagePaths[0], // Display the first image
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  // Heart Icon for favoriting
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        if (artwork['artworkId'] != null) {
                          if (isFavorited) {
                            favoritesProvider.removeFromFavorites(artwork);
                          } else {
                            favoritesProvider.addToFavorites(artwork);
                          }
                        } else {
                          print('Error: Artwork ID is null');
                        }
                      },
                      child: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  // Product Details
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(183, 123, 111, 111),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artwork['title'] ?? 'Unnamed Product',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${artwork['price']?.toStringAsFixed(2) ?? '0.00'}",
                            style: GoogleFonts.gabarito(
                              color: Colors.white,
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
      },
    );
  }
}
