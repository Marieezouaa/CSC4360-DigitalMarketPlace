
import 'package:digitalmarketplace/models/product_card.dart';
import 'package:digitalmarketplace/pages/settings_screens/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favoriteIds = favoritesProvider.favorites;

          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Favorites Yet',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // Fetch all artworks (replace this with actual data fetching logic)
          final allArtworks = [
  {
    "artworkId": "c3f3f5a1-7b23-4e89-95a4-d7b2f39a1c76",
    "title": "Whispers of the Forest",
    "price": 85.00,
    "imagePaths": ["assets/images/filler_images/Nature.png"]
  },
  {
    "artworkId": "e4d7bfa9-9f37-41e5-9ad1-c6f4b8b3c523",
    "title": "Golden Horizon",
    "price": 55.00,
    "imagePaths": ["assets/images/filler_images/Landscape.png"]
  },
  {
    "artworkId": "a81f4c9b-61e3-4d18-8359-b8a2f90d5f23",
    "title": "Urban Rhythms",
    "price": 75.00,
    "imagePaths": ["assets/images/filler_images/Abstract.png"]
  },
  {
    "artworkId": "d27a4c0e-7a18-4f90-8db1-a1b7f52d9c12",
    "title": "Ethereal Dreamscape",
    "price": 100.00,
    "imagePaths": ["assets/images/filler_images/Fantasy.png"]
  },
  {
    "artworkId": "b4a8c3f5-0d61-4fa9-a2f3-7b81c9d6e518",
    "title": "Harmony in Chaos",
    "price": 112.00,
    "imagePaths": ["assets/images/filler_images/Surrealism.png"]
  },
  {
    "artworkId": "f6e1d2a9-43f9-42d0-8f35-a3d2b9c0f471",
    "title": "Reflections of Solitude",
    "price": 165.00,
    "imagePaths": ["assets/images/filler_images/Portraiture.png"]
  }
];


          final favoriteArtworks = allArtworks.where((artwork) {
            return favoriteIds.contains(artwork['artworkId']);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favoriteArtworks.length,
            itemBuilder: (context, index) {
              final artwork = favoriteArtworks[index];

              final List<String> imagePaths = artwork['imagePaths'] is List
                  ? List<String>.from(artwork['imagePaths'] as List)
                  : [];

              return ProductCard(
                artwork: artwork,
                imagePaths: imagePaths,
              );
            },
          );
        },
      ),
    );
  }
}
