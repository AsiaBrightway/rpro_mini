import 'dart:ui';

class AppColors{
  static Color colorPrimary = const Color.fromRGBO(79, 45, 127, 1);
  // static Color colorPrimary = const Color.fromRGBO(209, 169, 240, 1);
  static Color colorOtp = const Color.fromRGBO(255, 125, 30, 1);
  static Color colorSecondaryText = const Color.fromRGBO(0, 0, 0, 0.5);
  static Color colorSeeAll = const Color.fromRGBO(111, 68, 209, 1);
  static Color colorWishListBg = const Color.fromRGBO(236, 235, 235, 0.6);
  static Color colorPrimary50 = ColorsWithOpacity.withOpacity(colorPrimary, 0.5);
  static Color colorNavBackground = const Color.fromRGBO(168, 130, 255, 1);
  static Color colorSearchBackground = const Color.fromRGBO(255, 251, 251, 1);
  static Color color102 = const Color.fromRGBO(102, 102, 102, 1);
  static Color colorWhite = const Color.fromRGBO(255, 255, 255, 1);
  static Color colorPrice = const Color.fromRGBO(255, 255, 0, 1);
  static Color cartBgColor = const Color.fromRGBO(72, 49, 103, 1);
  static Color deliveryAddressBg = const Color.fromRGBO(217, 217, 217, 0.3);
}

class ColorsWithOpacity {
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity); // Adjusts the opacity dynamically
  }
}