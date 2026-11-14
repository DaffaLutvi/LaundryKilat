import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laundry_kilat/app.dart';

void main() {
  // Smoke test: memompa seluruh aplikasi agar seluruh layar (View + ViewModel
  // + Repository + Service) terkompilasi sekaligus memastikan tidak ada
  // pengecualian saat aplikasi pertama kali dibangun.
  testWidgets('aplikasi terbangun dan menampilkan navigasi 4 tab',
      (tester) async {
    await tester.pumpWidget(const LaundryKilatApp());

    // Frame pertama: layar sedang memuat (loading state).
    await tester.pump();

    // Tunggu simulasi server (delay 800ms) selesai diproses.
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();

    // Navigasi bawah dan keempat tujuan tampil.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Jadwal'), findsWidgets);
    expect(find.text('Checklist'), findsWidgets);
    expect(find.text('Info'), findsWidgets);
  });
}
