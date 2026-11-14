import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_kilat/data/repositories/info_repository.dart';
import 'package:laundry_kilat/data/services/laundry_service.dart';
import 'package:laundry_kilat/domain/models/info_laundry.dart';
import 'package:laundry_kilat/ui/info_promo/info_promo_view_model.dart';

/// Service palsu yang mengganti data [getInfo] tanpa jeda, sehingga test
/// berjalan cepat dan terkendali.
class _FakeLaundryService extends LaundryService {
  _FakeLaundryService(this.infoData);

  final List<Map<String, dynamic>> infoData;

  @override
  Future<List<Map<String, dynamic>>> getInfo() async => infoData;
}

void main() {
  late InfoPromoViewModel vm;

  setUp(() async {
    final service = _FakeLaundryService([
      {
        'id': 'I1',
        'judul': 'Promo Akhir Pekan',
        'deskripsi': 'Diskon 20% sabtu-minggu.',
        'kategori': 'Promo',
        'penting': true,
        'tanggal': '2026-11-01',
      },
      {
        'id': 'I2',
        'judul': 'Paket Hemat Kilauan',
        'deskripsi': 'Cucian 5kg hanya Rp30.000.',
        'kategori': 'Paket',
        'penting': false,
        'tanggal': '2026-11-01',
      },
      {
        'id': 'I3',
        'judul': 'Libur Sementara',
        'deskripsi': 'Toko tutup tanggal 10 November.',
        'kategori': 'Pengumuman',
        'penting': true,
        'tanggal': '2026-11-03',
      },
      {
        'id': 'I4',
        'judul': 'Promo Member',
        'deskripsi': 'Cashback 10% tiap order member.',
        'kategori': 'Promo',
        'penting': false,
        'tanggal': '2026-11-02',
      },
    ]);
    final repo = InfoRepository(service);
    vm = InfoPromoViewModel(repo);
    await vm.load();
  });

  test('filter "semua" menampilkan seluruh info', () {
    expect(vm.filter, InfoFilter.semua);
    expect(vm.filtered.length, 4);
  });

  test('filter "promo" hanya menampilkan info kategori Promo', () {
    vm.setFilter(InfoFilter.promo);

    expect(vm.filtered.length, 2);
    expect(vm.filtered.every((i) => i.kategori == KategoriInfo.promo), isTrue);
    expect(
      vm.filtered.map((i) => i.judul).toList(),
      ['Promo Akhir Pekan', 'Promo Member'],
    );
  });

  test('filter "paket" hanya menampilkan info kategori Paket', () {
    vm.setFilter(InfoFilter.paket);

    expect(vm.filtered.length, 1);
    expect(vm.filtered.first.kategori, KategoriInfo.paket);
    expect(vm.filtered.first.judul, 'Paket Hemat Kilauan');
  });

  test('filter "pengumuman" hanya menampilkan info kategori Pengumuman', () {
    vm.setFilter(InfoFilter.pengumuman);

    expect(vm.filtered.length, 1);
    expect(vm.filtered.first.kategori, KategoriInfo.pengumuman);
    expect(vm.filtered.first.judul, 'Libur Sementara');
  });

  test('mengganti filter memberi tahu pendengar', () {
    var notified = 0;
    vm.addListener(() => notified++);

    vm.setFilter(InfoFilter.paket);
    expect(notified, 1);

    // Memilih filter yang sama tidak boleh memberi tahu ulang.
    vm.setFilter(InfoFilter.paket);
    expect(notified, 1);
  });

  test('info penting tetap terbaca pada data', () {
    final penting = vm.filtered.where((i) => i.penting).toList();
    expect(penting.length, 2);
    expect(penting.map((i) => i.judul).toList(),
        ['Promo Akhir Pekan', 'Libur Sementara']);
  });
}
