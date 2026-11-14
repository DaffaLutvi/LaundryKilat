import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/jadwal_repository.dart';
import '../../domain/models/jadwal_laundry.dart';
import '../core/widgets.dart';
import 'jadwal_view_model.dart';

/// Tab Jadwal: daftar jadwal dengan [SegmentedButton] 3 segmen
/// (Antar, Jemput, Ambil di Toko).
class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = JadwalViewModel(context.read<JadwalRepository>())..load();
        return vm;
      },
      child: const _JadwalView(),
    );
  }
}

class _JadwalView extends StatelessWidget {
  const _JadwalView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<JadwalViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.isLoading) return const LoadingState();
          if (vm.error != null) {
            return ErrorState(message: vm.error!, onRetry: vm.load);
          }
          final jadwal = vm.filtered;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<JenisLayanan>(
                  segments: const [
                    ButtonSegment(value: JenisLayanan.antar, label: Text('Antar')),
                    ButtonSegment(value: JenisLayanan.jemput, label: Text('Jemput')),
                    ButtonSegment(
                      value: JenisLayanan.ambilDiToko,
                      label: Text('Ambil di Toko'),
                    ),
                  ],
                  selected: {vm.segment},
                  onSelectionChanged: (selection) => vm.setSegment(selection.first),
                ),
              ),
              Expanded(
                child: jadwal.isEmpty
                    ? const EmptyState(
                        icon: Icons.event_busy_outlined,
                        message: 'Tidak ada jadwal pada segmen ini.',
                      )
                    : RefreshIndicator(
                        onRefresh: vm.load,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: jadwal.map(_JadwalCard.new).toList(),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
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
        leading: const CircleAvatar(child: Icon(Icons.local_shipping_outlined)),
        title: Text(jadwal.namaPelanggan),
        subtitle: Text(
          '${jadwal.hari}, ${jadwal.waktu} WIB\n'
          '${jadwal.alamat == '-' ? 'Datang ke toko' : jadwal.alamat} · '
          '${jadwal.beratKg} kg',
        ),
        isThreeLine: true,
        trailing: Chip(label: Text(jadwal.jenisLayanan.label)),
      ),
    );
  }
}
