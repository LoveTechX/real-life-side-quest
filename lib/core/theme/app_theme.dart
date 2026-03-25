import 'package:flutter/material.dart';

import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(useMaterial3: true, textTheme: AppTextStyles.textTheme);
  }
}
