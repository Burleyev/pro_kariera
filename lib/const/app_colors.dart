import 'package:flutter/material.dart';

class AppColors {
  // Основний фон
  static const Color background = Color(0xFFFAF5F0); // Білий

  // Текст
  static const Color textPrimary = Color(0xFF333333); // Темно-сірий
  static const Color textSecondary = Color(0xFF666666); // Сірий для підписів

  // Акцентні кольори
  static const Color primary = Color(0xFF1278C2); // Темно-синій
  static const Color secondary = Color(0xFF1C2B4A); // Блакитний
  static const Color secondaryLight = Color(0xFF90CAF9); // Світло-блакитний

  // Кнопки та елементи інтерфейсу
  static const Color button = primary;
  static const Color buttonHover = secondary;

  // Додаткові (опційно)
  static const Color warmAccent = Color(
    0xFFFDEEEA,
  ); // Теплий акцент (наприклад, для AVGS)
}
