import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// ProductDetails widget
class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> artwork;

  const ProductDetails({required this.artwork, Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int itemCount = 1; // Default quantity
  bool isFavorite = false; // State to track favorite status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pop(context), // Back button logic
                        child: const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite; // Toggle favorite status
                          });
                        },
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border, // Material Icons
                          color: isFavorite ? Colors.red : Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  _getAssetImageForArtwork(widget.artwork['category']),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.artwork['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.artwork['description'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Category: ${widget.artwork['category']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Created at: ${widget.artwork['createdAt']}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 390,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(117, 152, 151, 176),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Quantity"),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (itemCount > 1) itemCount--;
                            });
                          },
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedMinusSign,
                            color: Colors.black,
                            size: 24.0,
                          ),
                        ),
                        Text(
                          "$itemCount",
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              itemCount++;
                            });
                          },
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedAdd01,
                            color: Colors.black,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: addToCart,
                child: Container(
                  width: 380,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 152, 151, 176),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${widget.artwork['price'].toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Text(
                          "Add to Bag",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAssetImageForArtwork(String category) {
    switch (category) {
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

  void addToCart() {
  }
}
