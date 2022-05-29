import 'package:flutter/material.dart';

class CustomTheme extends ChangeNotifier {
  bool _isDarkTheme = true;

  ThemeMode currentTheme() {
    if (_isDarkTheme) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(backgroundColor: Colors.black),
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: Color(0xFF1A1910),
    colorScheme: ColorScheme.dark(),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.blueAccent,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
    )),
    dividerColor: Colors.grey[600],
  );

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFeeeeee),
    primaryColor: Color(0xFFeeeeee),
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFF000000), elevation: 0),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.blueAccent,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
    )),
  );
}
