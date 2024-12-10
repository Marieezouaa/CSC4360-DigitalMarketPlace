import 'package:digitalmarketplace/models/product_card.dart';
import 'package:digitalmarketplace/models/trending_banner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
// Import TrendingBanner widget (make sure this is implemented)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DB",
                        style: GoogleFonts.spicyRice(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, size: 30),
                        onPressed: () {
                          // Navigate to cart
                        },
                      ),
                    ],
                  ),
                ),

                // Horizontal Scrolling Section for Trending Banners
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TrendingBanner(title: "Browse Trending Artists"),
                      const SizedBox(width: 16),
                      TrendingBanner(title: "Discover New Artworks"),
                      const SizedBox(width: 16),
                      TrendingBanner(title: "Popular Digital Artists"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fetching Artwork Data from Firebase
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('artworks') // Access your Firestore collection
                        .where('isAvailable', isEqualTo: true) // Only available artworks
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No artworks available.'));
                      }

                      // Map the Firestore documents to ProductCard widgets
                      final artworks = snapshot.data!.docs;
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8, // Adjust for card height
                        ),
                        itemCount: artworks.length,
                        itemBuilder: (context, index) {
                          final artwork = artworks[index];
                          return ProductCard(
                            productId: artwork['artworkId'],
                            productName: artwork['title'],
                            productPrice: artwork['price'].toDouble(),
                            imagePaths: [artwork['imageUrl']], // Assuming imageUrl contains the image path
                            secondaryColor: Colors.blueGrey,
                            collection: artwork['category'],
                          );
                        },
                      );
                    },
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
