import 'package:flutter/material.dart';

/// Tema aplikasi Laundry Kilat berbasis Material 3.
///
/// Warna utama diambil dari seed indigo sehingga seluruh komponen mengikuti
/// satu skema warna yang konsisten.
ThemeData appTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(centerTitle: true, backgroundColor: colorScheme.surface),
  );
}
