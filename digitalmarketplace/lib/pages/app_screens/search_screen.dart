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

  final firestore = FirebaseFirestore.instance;


  final searchQuery = query.toLowerCase();


  List<Map<String, String>> results = [];

  try {

    final artworkSnapshot = await firestore
        .collection('artworks')
        .where('isAvailable', isEqualTo: true) 
        .get();

    for (var doc in artworkSnapshot.docs) {
      final data = doc.data();
      if (data['title'].toString().toLowerCase().contains(searchQuery) ||
          data['description'].toString().toLowerCase().contains(searchQuery)) {
        results.add({
          'imageUrl': data['imageUrl'] ?? '',
          'title': data['title'] ?? 'Untitled',
          'subtitle': 'Artwork by ${data['artistName'] ?? 'Unknown Artist'}',
        });
      }
    }


    final artistSnapshot = await firestore
        .collection('user')
        .where('role', isEqualTo: 'artist')
        .get();

    for (var doc in artistSnapshot.docs) {
      final data = doc.data();
      if (data['artistName'].toString().toLowerCase().contains(searchQuery) ||
          data['bio'].toString().toLowerCase().contains(searchQuery)) {
        results.add({
          'imageUrl': '', 
          'title': data['artistName'] ?? 'Unknown Artist',
          'subtitle': data['bio'] ?? '',
        });
      }
    }
  } catch (e) {
    debugPrint('Error performing search: $e');
    rethrow;
  }

  
  return results;
}


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
