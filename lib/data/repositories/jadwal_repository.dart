import '../../domain/models/jadwal_laundry.dart';
import '../services/laundry_service.dart';

const _hariIndo = <String>[
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

/// Repository sumber kebenaran data jadwal.
///
/// Bertugas mengambil data mentah dari [LaundryService], mengubahnya menjadi
/// model [JadwalLaundry], dan menyimpan cache sehingga pemanggilan ulang tidak
/// perlu meminta data ke "server" lagi.
class JadwalRepository {
  JadwalRepository(this._service);

  final LaundryService _service;

  List<JadwalLaundry> _cache = const [];
  bool _loaded = false;

  /// Salinan daftar jadwal yang sudah dimuat (tidak boleh diubah dari luar).
  List<JadwalLaundry> get cache => List.unmodifiable(_cache);

  /// Nama hari berjalan dalam Bahasa Indonesia.
  String get namaHariIni => _hariIndo[DateTime.now().weekday - 1];

  /// Memuat seluruh jadwal. Mengembalikan cache bila sudah pernah dimuat,
  /// kecuali [force] `true`.
  Future<List<JadwalLaundry>> load({bool force = false}) async {
    if (_loaded && !force) return _cache;
    final raw = await _service.getJadwal();
    _cache = raw.map(JadwalLaundry.fromJson).toList(growable: false);
    _loaded = true;
    return _cache;
  }

  /// Mengembalikan jadwal yang jatuh pada hari berjalan.
  Future<List<JadwalLaundry>> getJadwalHariIni() async {
    final data = await load();
    return data.where((j) => j.hari == namaHariIni).toList(growable: false);
  }
}
