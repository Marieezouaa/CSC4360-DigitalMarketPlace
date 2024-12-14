import 'package:digitalmarketplace/models/product_card.dart';
import 'package:digitalmarketplace/models/trending_banner.dart';
import 'package:digitalmarketplace/pages/app_screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class ImagesList {
  final String productName;
  final List<String> images;

  ImagesList(this.productName, this.images);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalBanners = 3;

  // Dummy image list for demonstration purposes
  final List<ImagesList> images = [
    ImagesList(
        "Whispers of the Forest", ["assets/images/filler_images/Nature.png"]),
    ImagesList("Urban Rhythms", ["assets/images/filler_images/Abstract.png"]),
    ImagesList("Golden Horizon", ["assets/images/filler_images/Landscape.png"]),
    ImagesList(
        "Ethereal Dreamscape", ["assets/images/filler_images/Fantasy.png"]),
    ImagesList(
        "Harmony in Chaos", ["assets/images/filler_images/Surrealism.png"]),
    ImagesList("Reflections of Solitude",
        ["assets/images/filler_images/Portraiture.png"]),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Auto-scroll logic for banners
    Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _totalBanners;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                        icon: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF614CAF), // Start color
                              Color(0xFF9D6CFF), // Middle color
                              Color(0xFFFFA726), // End color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      CartScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Auto-scrolling Trending Banners
                SizedBox(
                    height: 120,
                    child: PageView.builder(
                      controller: _pageController,
                      allowImplicitScrolling: true, // This helps preserve state
                      itemBuilder: (context, index) {
                        return TrendingBanner(
                          title: [
                            "Browse Trending Artists",
                            "Discover New Artworks",
                            "Popular Digital Artists"
                          ][index % _totalBanners],
                          imagePath: [
                            "assets/images/banner_images/banner1.jpg",
                            "assets/images/banner_images/banner2.jpg",
                            "assets/images/banner_images/banner3.jpg"
                          ][index % _totalBanners],
                        );
                      },
                    )),
                const SizedBox(height: 16),

                // Fetching Artwork Data from Firebase
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('artworks')
                        .where('isAvailable', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No artworks available.'));
                      }

                      // Map the Firestore documents to ProductCard widgets
                      final artworks = snapshot.data!.docs;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8, // Adjust for card height
                        ),
                        itemCount: artworks.length,
                        itemBuilder: (context, index) {
                          final artwork = artworks[index];
                          final imageList = images.firstWhere(
                            (img) => img.productName == artwork['title'],
                            orElse: () => ImagesList("", []),
                          );

                          return ProductCard(
                            artwork: {
                              'artworkId': artwork['artworkId'],
                              'title': artwork['title'],
                              'price': artwork['price'],
                              'category': artwork['category'],
                              'description': artwork['description'],
                              'createdAt': artwork['createdAt'],
                            },
                            imagePaths: imageList.images.isNotEmpty
                                ? imageList.images
                                : ['assets/images/placeholder.png'],
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
