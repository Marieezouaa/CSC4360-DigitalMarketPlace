import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'artwork_database_helper.dart';

class ArtworkFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ArtworkDatabaseHelper _databaseHelper = ArtworkDatabaseHelper();

  Future<String> uploadArtwork({
    required String artistId,
    required String title,
    required String description,
    required String category,
    required double price,
    required List<File> imageFiles,
    List<String>? tags,
    bool isAvailable = true,
    bool isOnSale = true,
  }) async {
    try {
      // Generate a unique artwork ID
      final artworkId = const Uuid().v4();

      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (var imageFile in imageFiles) {
        final imageName = '$artworkId/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = _storage.ref().child(imageName);
        
        // Upload image to Firebase Storage
        final uploadTask = await storageRef.putFile(imageFile);
        final imageUrl = await uploadTask.ref.getDownloadURL();
        
        imageUrls.add(imageUrl);

        // Save local image path to SQLite
        await _databaseHelper.saveArtworkImage(
          artworkId, 
          artistId, 
          imageFile.path
        );
      }

      // Prepare artwork data
      final artworkData = {
        'artistId': artistId,
        'artworkId': artworkId,
        'category': category,
        'createdAt': DateTime.now().toIso8601String(),
        'currency': 'USD', // Default currency
        'description': description,
        'imageUrl': imageUrls.first, // Store first image URL
        'isAvailable': isAvailable,
        'isOnSale': isOnSale,
        'price': price,
        'salePrice': price, // Initially same as price
        'title': title,
        // Optional: add tags if provided
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      };

      // Upload to Firestore
      await _firestore.collection('artworks').doc(artworkId).set(artworkData);

      // Mark as synced in local database
      await _databaseHelper.markArtworkAsSynced(artworkId, artistId);

      return artworkId;
    } catch (e) {
      print('Error uploading artwork: $e');
      rethrow;
    }
  }

  // Fetch artwork details from Firestore
  Future<Map<String, dynamic>?> getArtworkById(String artworkId) async {
    try {
      final docSnapshot = await _firestore.collection('artworks').doc(artworkId).get();
      
      if (!docSnapshot.exists) return null;

      return docSnapshot.data();
    } catch (e) {
      print('Error fetching artwork: $e');
      return null;
    }
  }

  // Retrieve local image paths for an artwork
  Future<List<String>> getLocalArtworkImages(String artworkId) async {
    return await _databaseHelper.getArtworkImagePaths(artworkId);
  }

  // Method to handle offline sync or retry upload
  Future<void> syncOfflineArtworks(String userId) async {
    // Implement logic to check for unsynced artworks in local database
    // and attempt to upload them to Firebase
  }
}