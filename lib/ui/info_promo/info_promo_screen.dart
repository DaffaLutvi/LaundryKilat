import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/info_repository.dart';
import '../../domain/models/info_laundry.dart';
import '../core/widgets.dart';
import 'info_promo_view_model.dart';

/// Tab Info & Promo (fitur buatan sendiri).
///
/// Halaman kartu pengumuman untuk pelanggan laundry. Pengguna menyaring info
/// lewat chip kategori (Semua / Promo / Paket / Pengumuman), dan info penting
/// diberi label "Penting". Penyaringan diatur oleh [InfoPromoViewModel].
class InfoPromoScreen extends StatelessWidget {
  const InfoPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = InfoPromoViewModel(context.read<InfoRepository>())..load();
        return vm;
      },
      child: const _InfoPromoView(),
    );
  }
}

class _InfoPromoView extends StatelessWidget {
  const _InfoPromoView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<InfoPromoViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Info & Promo')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.isLoading) return const LoadingState();
          if (vm.error != null) {
            return ErrorState(message: vm.error!, onRetry: vm.load);
          }
          final info = vm.filtered;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: _FilterChips(vm: vm),
              ),
              Expanded(
                child: info.isEmpty
                    ? const EmptyState(
                        icon: Icons.campaign_outlined,
                        message: 'Tidak ada info pada kategori ini.',
                      )
                    : RefreshIndicator(
                        onRefresh: vm.load,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: info.map(_InfoCard.new).toList(),
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

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.vm});
  final InfoPromoViewModel vm;

  static const _labels = <InfoFilter, String>{
    InfoFilter.semua: 'Semua',
    InfoFilter.promo: 'Promo',
    InfoFilter.paket: 'Paket',
    InfoFilter.pengumuman: 'Pengumuman',
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final entry in _labels.entries)
          ChoiceChip(
            label: Text(entry.value),
            selected: vm.filter == entry.key,
            onSelected: (_) => vm.setFilter(entry.key),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(this.info);
  final InfoLaundry info;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    info.judul,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (info.penting)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Penting',
                      style: TextStyle(
                        color: colors.onErrorContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(info.deskripsi),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(info.kategori.label),
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                ),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today_outlined, size: 14, color: colors.outline),
                const SizedBox(width: 4),
                Text(info.tanggal, style: TextStyle(color: colors.outline)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
