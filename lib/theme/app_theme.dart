import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF7AB9FF); // #7AB9FF
  static const Color primaryDark = Color(0xFF1E90FF); // #1E90FF
  static const Color accent = Color(0xFFDCEEFF); // #DCEEFF
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: false);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
      ),

      // AppBar nhìn rõ hơn (vì nền xanh nhạt dễ bị “trôi”)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // chữ/icon trắng
        elevation: 0,
      ),

      scaffoldBackgroundColor: const Color(0xFFF1F4F7),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryDark,
            width: 1.5,
          ),
        ),
        prefixIconColor: AppColors.primaryDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF13353F),
        displayColor: const Color(0xFF13353F),
      ),
    );
  }
}
