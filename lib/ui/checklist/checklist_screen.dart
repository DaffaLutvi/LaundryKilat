import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/cucian_repository.dart';
import '../../domain/models/cucian_order.dart';
import '../core/widgets.dart';
import 'checklist_view_model.dart';

/// Tab Checklist: order cucian dengan [CheckboxListTile].
///
/// Item yang dicentang pindah ke bagian "Selesai". Tab ini juga menjadi sumber
/// badge jumlah order yang belum selesai pada navigasi bawah.
class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = ChecklistViewModel(context.read<CucianRepository>())..load();
        return vm;
      },
      child: const _ChecklistView(),
    );
  }
}

class _ChecklistView extends StatelessWidget {
  const _ChecklistView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ChecklistViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist Cucian')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.isLoading) return const LoadingState();
          if (vm.error != null) {
            return ErrorState(message: vm.error!, onRetry: vm.load);
          }
          final belum = vm.belumSelesai;
          final sudah = vm.selesai;
          return ListView(
            children: [
              SectionTitle(
                'Belum Selesai',
                trailing: Text('${belum.length} order'),
              ),
              if (belum.isEmpty)
                const EmptyState(
                  icon: Icons.check_circle_outline,
                  message: 'Tidak ada cucian yang belum selesai.',
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: belum.map(_CucianTile.new).toList(),
                  ),
                ),
              const Divider(height: 32),
              SectionTitle('Selesai', trailing: Text('${sudah.length} order')),
              if (sudah.isEmpty)
                const EmptyState(
                  icon: Icons.history_outlined,
                  message: 'Belum ada cucian yang selesai.',
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: sudah.map(_CucianTile.new).toList(),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _CucianTile extends StatelessWidget {
  const _CucianTile(this.order);
  final CucianOrder order;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ChecklistViewModel>();
    return Card(
      child: CheckboxListTile(
        value: order.isDone,
        onChanged: (_) => vm.toggleSelesai(order.id),
        title: Text(order.nama),
        subtitle: Text('${order.jenis} · ${order.beratKg} kg · ${order.tanggal}'),
      ),
    );
  }
}
