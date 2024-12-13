import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for artists or artworks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _searchQuery.isEmpty
                  ? const Center(
                      child: Text('Start typing to search for artists or artworks.'),
                    )
                  : FutureBuilder<List<dynamic>>(
                      future: _performSearch(_searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No results found.'));
                        }
                        final results = snapshot.data!;
                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = results[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(result['imageUrl']),
                              ),
                              title: Text(result['title']),
                              subtitle: Text(result['subtitle']),
                              onTap: () {
                                // Handle navigation or interaction with the result
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }



Future<List<Map<String, String>>> _performSearch(String query) async {
  // Reference to the Firestore instance
  final firestore = FirebaseFirestore.instance;

  // Normalize query for case-insensitive searching
  final searchQuery = query.toLowerCase();

  // Initialize an empty list to store search results
  List<Map<String, String>> results = [];

  try {
    // Fetch artworks that match the query in title or description
    final artworkSnapshot = await firestore
        .collection('artworks')
        .where('isAvailable', isEqualTo: true) // Only available artworks
        .get();

    for (var doc in artworkSnapshot.docs) {
      final data = doc.data();
      if (data['title'].toString().toLowerCase().contains(searchQuery) ||
          data['description'].toString().toLowerCase().contains(searchQuery)) {
        results.add({
          'imageUrl': data['imageUrl'] ?? '',
          'title': data['title'] ?? 'Untitled',
          'subtitle': 'Artwork by ${data['artistId'] ?? 'Unknown Artist'}',
        });
      }
    }

    // Fetch artists that match the query in userName or bio
    final artistSnapshot = await firestore
        .collection('user')
        .where('role', isEqualTo: 'artist') // Only artists
        .get();

    for (var doc in artistSnapshot.docs) {
      final data = doc.data();
      if (data['userName'].toString().toLowerCase().contains(searchQuery) ||
          data['bio'].toString().toLowerCase().contains(searchQuery)) {
        results.add({
          'imageUrl': '', // Placeholder or artist's profile image URL
          'title': data['userName'] ?? 'Unknown Artist',
          'subtitle': data['bio'] ?? '',
        });
      }
    }
  } catch (e) {
    debugPrint('Error performing search: $e');
    rethrow;
  }

  // Return the collected results
  return results;
}


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
