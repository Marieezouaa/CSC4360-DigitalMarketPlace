import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // List of cart items (empty for this version)
  List<Map<String, dynamic>> cartItems = [];

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['count']));
    double tax = 5.0;
    double total = subtotal + tax;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: GoogleFonts.spicyRice(),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cartItems.clear(); // Remove all items from the cart
              });
            },
            child: Text(
              "Remove All",
              style: GoogleFonts.spicyRice(color: Colors.white),
            ),
          )
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: GoogleFonts.spicyRice(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return cartItem(
                          item['title'],
                          item['size'],
                          item['color'],
                          item['price'],
                          item['count'],
                          () => setState(() => item['count']++),
                          () => setState(() => item['count'] = item['count'] > 1 ? item['count'] - 1 : 1),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                  summaryRow("Shipping Cost", "Free"),
                  summaryRow("Tax", "\$${tax.toStringAsFixed(2)}"),
                  summaryRow("Total", "\$${total.toStringAsFixed(2)}", isTotal: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for checkout
                    },
                    child: Text(
                      "Checkout",
                      style: GoogleFonts.spicyRice(),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget cartItem(
    String title,
    String size,
    String color,
    double price,
    int itemCount,
    VoidCallback onAdd,
    VoidCallback onRemove,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.image, size: 50), // Replace with actual image
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.spicyRice(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                "Size - $size",
                style: GoogleFonts.spicyRice(fontSize: 14),
              ),
              Text(
                "Color - $color",
                style: GoogleFonts.spicyRice(fontSize: 14),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: GoogleFonts.spicyRice(fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  "$itemCount",
                  style: GoogleFonts.spicyRice(fontSize: 16),
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spicyRice(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spicyRice(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}