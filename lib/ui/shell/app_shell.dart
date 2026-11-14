import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/cucian_repository.dart';
import '../checklist/checklist_screen.dart';
import '../home/home_screen.dart';
import '../info_promo/info_promo_screen.dart';
import '../jadwal/jadwal_screen.dart';

/// Kerangka aplikasi dengan bottom navigation 4 tab.
///
/// Tab Checklist memiliki badge berisi jumlah order yang belum selesai.
/// Badge ini mengikuti perubahan [CucianRepository] lewat `context.watch`.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _destinations = <Widget>[
    HomeScreen(),
    JadwalScreen(),
    ChecklistScreen(),
    InfoPromoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Mengikuti perubahan jumlah order belum selesai untuk badge.
    final jumlahBelum = context.select<CucianRepository, int>(
      (repo) => repo.jumlahBelumSelesai,
    );

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _destinations),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          const NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: _BadgeIcon(
              icon: const Icon(Icons.checklist_outlined),
              count: jumlahBelum,
            ),
            selectedIcon: _BadgeIcon(
              icon: const Icon(Icons.checklist),
              count: jumlahBelum,
            ),
            label: 'Checklist',
          ),
          const NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}

/// Ikon dengan badge angka di pojok kanan atas. Badge disembunyikan saat [count]
/// bernilai 0.
class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({required this.icon, required this.count});
  final Icon icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return icon;
    return Badge(
      label: Text('$count'),
      child: icon,
    );
  }
}
