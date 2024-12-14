import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ArtworkDatabaseHelper {
  static final ArtworkDatabaseHelper _instance = ArtworkDatabaseHelper._internal();
  static Database? _database;

  factory ArtworkDatabaseHelper() => _instance;

  ArtworkDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'artwork_database.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Local Artwork Images Table
    await db.execute('''
      CREATE TABLE local_artwork_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        artwork_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        image_path TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create Local Artwork Metadata Table (optional, for offline sync)
    await db.execute('''
      CREATE TABLE local_artwork_metadata (
        artwork_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        firebase_sync_status INTEGER DEFAULT 0
      )
    ''');
  }

  // Save local image path for an artwork
  Future<int> saveArtworkImage(String artworkId, String userId, String imagePath) async {
    final db = await database;
    return await db.insert('local_artwork_images', {
      'artwork_id': artworkId,
      'user_id': userId,
      'image_path': imagePath,
      'created_at': DateTime.now().toIso8601String()
    });
  }

  // Get all image paths for a specific artwork
  Future<List<String>> getArtworkImagePaths(String artworkId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'local_artwork_images',
      where: 'artwork_id = ?',
      whereArgs: [artworkId]
    );

    return results.map((map) => map['image_path'] as String).toList();
  }

  // Delete local images for an artwork
  Future<int> deleteArtworkImages(String artworkId) async {
    final db = await database;
    return await db.delete(
      'local_artwork_images',
      where: 'artwork_id = ?',
      whereArgs: [artworkId]
    );
  }

  // Mark artwork as synced with Firebase
  Future<int> markArtworkAsSynced(String artworkId, String userId) async {
    final db = await database;
    return await db.insert(
      'local_artwork_metadata',
      {
        'artwork_id': artworkId,
        'user_id': userId,
        'firebase_sync_status': 1
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Check if artwork is already synced
  Future<bool> isArtworkSynced(String artworkId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'local_artwork_metadata',
      where: 'artwork_id = ? AND firebase_sync_status = 1',
      whereArgs: [artworkId]
    );

    return results.isNotEmpty;
  }
}