import '../../domain/models/info_laundry.dart';
import '../services/laundry_service.dart';

/// Repository sumber kebenaran data info, promo, dan pengumuman.
///
/// Mengambil data mentah dari [LaundryService], mengubahnya menjadi model
/// [InfoLaundry], dan menyimpan cache.
class InfoRepository {
  InfoRepository(this._service);

  final LaundryService _service;

  List<InfoLaundry> _cache = const [];
  bool _loaded = false;

  /// Salinan daftar info yang sudah dimuat (tidak boleh diubah dari luar).
  List<InfoLaundry> get cache => List.unmodifiable(_cache);

  /// Memuat daftar info. Mengembalikan cache bila sudah pernah dimuat,
  /// kecuali [force] `true`.
  Future<List<InfoLaundry>> load({bool force = false}) async {
    if (_loaded && !force) return _cache;
    final raw = await _service.getInfo();
    _cache = raw.map(InfoLaundry.fromJson).toList(growable: false);
    _loaded = true;
    return _cache;
  }
}
