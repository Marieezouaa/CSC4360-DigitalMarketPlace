import 'package:digitalmarketplace/models/product_card.dart';
import 'package:digitalmarketplace/models/trending_banner.dart';
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
    ImagesList("Artwork 1", ["assets/images/art1_1.jpg", "assets/images/art1_2.jpg"]),
    ImagesList("Artwork 2", ["assets/images/art2_1.jpg"]),
    ImagesList("Artwork 3", ["assets/images/art3_1.jpg", "assets/images/art3_2.jpg"]),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Auto-scroll logic for banners
    Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;
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
                          // Navigate to cart
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
                    onPageChanged: (index) {
                      // Handle infinite scroll
                      if (index == _totalBanners) {
                        Future.delayed(
                          const Duration(milliseconds: 300),
                          () {
                            _pageController.jumpToPage(0);
                          },
                        );
                      }
                      setState(() {
                        _currentPage = index % _totalBanners;
                      });
                    },
                    itemCount: _totalBanners + 1, // Extra item for looping
                    itemBuilder: (context, index) {
                      final isLast = index == _totalBanners;
                      return TrendingBanner(
                        title: isLast
                            ? "Browse Trending Artists" // Title of the first banner
                            : [
                                "Browse Trending Artists",
                                "Discover New Artworks",
                                "Popular Digital Artists"
                              ][index],
                        imagePath: isLast
                            ? "assets/images/banner_images/banner1.jpg" // Image path of the first banner
                            : [
                                "assets/images/banner_images/banner1.jpg",
                                "assets/images/banner_images/banner2.jpg",
                                "assets/images/banner_images/banner3.jpg"
                              ][index],
                      );
                    },
                  ),
                ),
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
