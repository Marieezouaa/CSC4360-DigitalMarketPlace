import 'package:flutter/foundation.dart';

class FavoritesProvider with ChangeNotifier {
  // Using a Set for artworkIds to ensure uniqueness
  final Set<String> _favorites = {};

  // Getter for the list of favorites (IDs)
  Set<String> get favorites => _favorites;

  /// Adds artwork ID to favorites if not already present
  void addToFavorites(Map<String, dynamic> artwork) {
    if (artwork['artworkId'] != null && !_favorites.contains(artwork['artworkId'])) {
      _favorites.add(artwork['artworkId']); // Store only the artworkId
      notifyListeners();
    }
  }

  /// Removes artwork from favorites based on artworkId
  void removeFromFavorites(Map<String, dynamic> artwork) {
    if (artwork['artworkId'] != null) {
      _favorites.remove(artwork['artworkId']);
      notifyListeners();
    }
  }

  /// Checks if an artwork is favorited based on artworkId
  bool isFavorite(Map<String, dynamic> artwork) {
    return artwork['artworkId'] != null && _favorites.contains(artwork['artworkId']);
  }

  /// Utility to clear all favorites (optional)
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
