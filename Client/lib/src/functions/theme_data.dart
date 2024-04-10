import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SYNCThemeData {
  static ValueNotifier<ThemeMode>? _themeNotifier;
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      secondary: Colors.black87,
      primary: Colors.blue,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.blueGrey,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
          statusBarIconBrightness: Brightness.light),
    ),
  );

  static final ThemeData _darkTheme1 = ThemeData(
    brightness: Brightness.dark,
    primaryIconTheme: const IconThemeData(
      color: Colors.amberAccent,
    ),
    colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(255, 18, 18, 18),
      secondary: Colors.deepOrangeAccent,
      primary: Colors.amber,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.amber,
          statusBarIconBrightness: Brightness.dark),
    ),
  );

  static final ThemeData _darkTheme2 = ThemeData(
    brightness: Brightness.dark,
    primaryIconTheme: const IconThemeData(
      color: Colors.purpleAccent,
    ),
    colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(255, 18, 18, 18),
      secondary: Colors.purpleAccent,
      primary: Colors.deepPurple,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.deepPurple,
          statusBarIconBrightness: Brightness.dark),
    ),
  );

  static final ThemeData _darkTheme3 = ThemeData(
    brightness: Brightness.dark,
    primaryIconTheme: const IconThemeData(
      color: Colors.blueAccent,
    ),
    colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(255, 18, 18, 18),
      secondary: Colors.lightBlueAccent,
      primary: Colors.indigo,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.indigo,
          statusBarIconBrightness: Brightness.dark),
    ),
  );

  static ThemeData? returnDarkThemeData;

  static ThemeData get getDarkTheme => returnDarkThemeData!;
  static ThemeData get getLightTheme => _lightTheme;

  static ValueNotifier<ThemeMode>? get getThemeNotifier => _themeNotifier;

  static Future<void> darkThemeState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('isDarkTheme') == null) {
      _themeNotifier = ValueNotifier(ThemeMode.system);
      preferences.setBool('isDarkTheme', false);
    }
    if (!preferences.getBool('isDarkTheme')!) {
      _themeNotifier = ValueNotifier(ThemeMode.light);
    } else {
      _themeNotifier = ValueNotifier(ThemeMode.dark);
    }
  }

  static Future<void> saveDarkTheme(bool state) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkTheme', state);
    await selectDarkTheme();
  }

  static Future<bool?> getDarkThemeState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('isDarkTheme');
  }

  static Future<void> selectDarkTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<bool> getDarkThemeStates = [
      preferences.getBool("theme1") ?? false,
      preferences.getBool("theme2") ?? false,
      preferences.getBool("theme3") ?? false
    ];
    if (getDarkThemeStates[0]) {
      returnDarkThemeData = _darkTheme1;
    }
    if (getDarkThemeStates[1]) {
      returnDarkThemeData = _darkTheme2;
    }
    if (getDarkThemeStates[2]) {
      returnDarkThemeData = _darkTheme3;
    }
    if (!getDarkThemeStates[0] &&
        !getDarkThemeStates[1] &&
        !getDarkThemeStates[2]) {
      returnDarkThemeData = _darkTheme3;
    }
    await preferences.setBool("theme1", getDarkThemeStates[0]);
    await preferences.setBool("theme2", getDarkThemeStates[1]);
    await preferences.setBool("theme3", getDarkThemeStates[2]);
    print("theme1 = ${getDarkThemeStates[0]}");
    print("theme2 = ${getDarkThemeStates[1]}");
    print("theme3 = ${getDarkThemeStates[2]}");
  }

  static Future<bool> clearThemeState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }
}
