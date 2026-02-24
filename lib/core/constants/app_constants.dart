import 'package:flutter/widgets.dart';

class AppRadius {
  // Radius for small components like Checkboxes or mini Tags
  static BorderRadius checkbox = BorderRadius.circular(4);

  // Default radius for TextFields and Input decorations
  static BorderRadius textField = BorderRadius.circular(20);

  /// Standard radius for Buttons (Login, Register, etc.)
  static BorderRadius button = BorderRadius.circular(12);

  // Radius for Cards and large Containers in the Product Catalog
  static BorderRadius card = BorderRadius.circular(16);
}

class AppConstants {
  static const String userSession = 'user_session';
  static const String usersCollectionName = 'Users';
  static const String cartCollectionName = 'Cart';
  static const String wishlistCollectionName = 'Wishlist';
  static const String addressesCollectionName = 'Addresses';
}
