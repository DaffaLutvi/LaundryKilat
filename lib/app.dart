import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'ui/core/theme.dart';
import 'ui/shell/app_shell.dart';

/// Widget akar aplikasi Laundry Kilat.
///
/// Membungkus seluruh aplikasi dengan [MultiProvider] berisi daftar
/// [providerDependencies], lalu menyediakan [MaterialApp] bertema Material 3.
class LaundryKilatApp extends StatelessWidget {
  const LaundryKilatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providerDependencies,
      child: MaterialApp(
        title: 'Laundry Kilat',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: const AppShell(),
      ),
    );
  }
}
