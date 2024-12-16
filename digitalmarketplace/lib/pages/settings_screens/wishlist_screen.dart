import 'package:digitalmarketplace/models/product_card.dart';
import 'package:digitalmarketplace/models/product_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);


  String _getAssetImageForArtwork(String? category) {
  switch (category ?? 'default') { 
    case 'nature':
      return 'assets/images/filler_images/Nature.png';
    case 'abstract':
      return 'assets/images/filler_images/Abstract.png';
    case 'landscape':
      return 'assets/images/filler_images/Landscape.png';
    case 'fantasy':
      return 'assets/images/filler_images/Fantasy.png';
    case 'surrealism':
      return 'assets/images/filler_images/Surrealism.png';
    case 'portraiture':
      return 'assets/images/filler_images/Portraiture.png';
    default:
      return 'assets/images/filler_images/Portraiture.png';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist", style: GoogleFonts.spicyRice()),
        centerTitle: true,
      ),
      body: CartState.wishlist.isEmpty
          ? Center(
              child: Text(
                "Your wishlist is empty",
                style: GoogleFonts.spicyRice(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: CartState.wishlist.length,
              itemBuilder: (context, index) {
                final product = CartState.wishlist[index];
                return GestureDetector(
                  onLongPress: () {
                    CartState.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${product['title']} added back to Cart")),
                    );
                  },
                  child: ProductCard(
                    artwork: product,
                    imagePaths: [
                      _getAssetImageForArtwork(product['category'] ?? 'default'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
