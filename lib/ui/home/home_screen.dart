import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/cucian_repository.dart';
import '../../data/repositories/jadwal_repository.dart';
import '../../domain/models/cucian_order.dart';
import '../../domain/models/jadwal_laundry.dart';
import '../core/widgets.dart';
import 'home_view_model.dart';

/// Tab Beranda: gabungan jadwal hari ini dan cucian yang belum selesai.
///
/// Setiap layar memiliki satu ViewModel yang ditampilkan memakai
/// [ListenableBuilder]. ViewModel dibuat memakai [ChangeNotifierProvider]
/// yang terhubung ke repository.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = HomeViewModel(
          context.read<JadwalRepository>(),
          context.read<CucianRepository>(),
        )..load();
        return vm;
      },
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.isLoading) return const LoadingState();
          if (vm.error != null) {
            return ErrorState(message: vm.error!, onRetry: vm.load);
          }
          return RefreshIndicator(
            onRefresh: vm.load,
            child: ListView(
              children: [
                _JadwalHariIniSection(vm: vm),
                const Divider(height: 32),
                _CucianBelumSelesaiSection(vm: vm),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _JadwalHariIniSection extends StatelessWidget {
  const _JadwalHariIniSection({required this.vm});
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final jadwal = vm.jadwalHariIni;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Jadwal Hari Ini (${vm.namaHariIni})'),
        if (jadwal.isEmpty)
          const EmptyState(
            icon: Icons.event_busy_outlined,
            message: 'Tidak ada jadwal untuk hari ini.',
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: jadwal.map(_JadwalCard.new).toList(),
            ),
          ),
      ],
    );
  }
}

class _JadwalCard extends StatelessWidget {
  const _JadwalCard(this.jadwal);
  final JadwalLaundry jadwal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.local_laundry_service)),
        title: Text(jadwal.namaPelanggan),
        subtitle: Text(
          '${jadwal.jenisLayanan.label} · ${jadwal.waktu} WIB\n'
          '${jadwal.alamat == '-' ? 'Datang ke toko' : jadwal.alamat} · '
          '${jadwal.beratKg} kg',
        ),
        isThreeLine: true,
        trailing: Chip(label: Text(jadwal.jenisLayanan.label)),
      ),
    );
  }
}

class _CucianBelumSelesaiSection extends StatelessWidget {
  const _CucianBelumSelesaiSection({required this.vm});
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final cucian = vm.belumSelesai;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Cucian Belum Selesai',
          trailing: Text('${cucian.length} order'),
        ),
        if (cucian.isEmpty)
          const EmptyState(
            icon: Icons.check_circle_outline,
            message: 'Semua cucian sudah selesai.',
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: cucian.map(_CucianCard.new).toList(),
            ),
          ),
      ],
    );
  }
}

class _CucianCard extends StatelessWidget {
  const _CucianCard(this.order);
  final CucianOrder order;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    return Card(
      child: CheckboxListTile(
        value: order.isDone,
        onChanged: (_) => vm.toggleSelesai(order.id),
        title: Text(order.nama),
        subtitle: Text(
          '${order.jenis} · ${order.beratKg} kg · ${order.tanggal}',
        ),
      ),
    );
  }
}
