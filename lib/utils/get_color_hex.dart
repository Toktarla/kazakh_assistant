import 'dart:ui';

Color? hexToColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return null;
  }

  // Remove the '#' if it exists
  String formattedHexColor = hexColor.startsWith('#')
      ? hexColor.substring(1)
      : hexColor;

  // Handle the short-form hex color (#RGB)
  if (formattedHexColor.length == 3) {
    formattedHexColor = formattedHexColor.split('').map((c) => c + c).join();
  }

  if (formattedHexColor.length != 6) {
    return null; // Return null for invalid format, you might want to throw an exception
  }

  int? colorInt = int.tryParse(formattedHexColor, radix: 16);
  if (colorInt == null) {
    return null; // Return null if parsing fails
  }

  return Color(0xFF000000 + colorInt); // Use 0xFF000000 for full opacity
}