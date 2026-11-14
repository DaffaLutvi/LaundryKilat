import 'package:flutter/foundation.dart';

import '../../data/repositories/info_repository.dart';
import '../../domain/models/info_laundry.dart';

/// Filter kategori yang tersedia pada tab Info & Promo.
enum InfoFilter { semua, promo, paket, pengumuman }

/// ViewModel untuk tab Info & Promo (fitur buatan sendiri).
///
/// Menyimpan seluruh info dan menyaringnya berdasarkan kategori yang dipilih.
/// Seluruh logika penyaringan ada di sini (bukan di widget) sehingga mudah
/// diuji tanpa layar.
class InfoPromoViewModel extends ChangeNotifier {
  InfoPromoViewModel(this._repo);

  final InfoRepository _repo;

  List<InfoLaundry> _all = const [];
  InfoFilter _filter = InfoFilter.semua;
  bool _isLoading = false;
  String? _error;

  /// Filter kategori yang sedang aktif.
  InfoFilter get filter => _filter;

  /// Hasil info yang sudah disaring sesuai filter aktif.
  List<InfoLaundry> get filtered => switch (_filter) {
        InfoFilter.semua => List.unmodifiable(_all),
        InfoFilter.promo =>
          _all.where((i) => i.kategori == KategoriInfo.promo).toList(),
        InfoFilter.paket =>
          _all.where((i) => i.kategori == KategoriInfo.paket).toList(),
        InfoFilter.pengumuman =>
          _all.where((i) => i.kategori == KategoriInfo.pengumuman).toList(),
      };

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Mengganti filter aktif lalu memberi tahu pendengar.
  void setFilter(InfoFilter value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  /// Memuat daftar info dari repository.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _repo.load();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
