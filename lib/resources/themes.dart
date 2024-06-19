import 'package:flutter/material.dart';
import 'package:web3_wallet/resources/resources.dart';

class AppThemes {
  static AppThemes? _instance;

  AppThemes._();

  factory AppThemes() {
    _instance ??= AppThemes._();
    return _instance!;
  }

  ThemeData get lightTheme => _lightTheme;

  ThemeData get darkTheme => _darkTheme;

  static const TextTheme _lightTextTheme = TextTheme(
    // H1
    displayLarge: TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
      fontSize: 32,
    ),
    //H2
    displayMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    // H3
    displaySmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    // Tab active, small text bold
    headlineLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    // Tab inactive, button link, small percentage, // small title medium
    headlineMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 28,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );

  final _lightTheme = ThemeData(
    textTheme: _lightTextTheme.apply(
      displayColor: AppColors.lightMode().softPurple,
      bodyColor: AppColors.lightMode().purple1,
    ),
    scaffoldBackgroundColor: AppColors.darkMode().bgScreen,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightMode().bgScreen,
      foregroundColor: AppColors.darkMode().title,
      titleTextStyle: _lightTextTheme.displayMedium,
      centerTitle: true,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.lightMode().purple1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: TextStyle(color: AppColors.lightMode().red), // Set your desired error text color here
    ),
    useMaterial3: true,
    fontFamily: "Poppins",
    extensions: <ThemeExtension<dynamic>>[
      AppColors.lightMode(),
    ],
  );

  final _darkTheme = ThemeData(
    textTheme: _lightTextTheme.apply(
      bodyColor: AppColors.darkMode().title,
      displayColor: AppColors.darkMode().title,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkMode().bgScreen,
      foregroundColor: AppColors.darkMode().title,
      titleTextStyle: _lightTextTheme.displayMedium,
      centerTitle: true,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.darkMode().purple1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: TextStyle(color: AppColors.darkMode().red), // Set your desired error text color here
    ),
    scaffoldBackgroundColor: AppColors.darkMode().bgScreen,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      AppColors.darkMode(),
    ],
  );
}
