import 'package:flutter/foundation.dart';

import '../../data/repositories/jadwal_repository.dart';
import '../../domain/models/jadwal_laundry.dart';

/// ViewModel untuk tab Jadwal.
///
/// Menyimpan seluruh jadwal dan menyaringnya berdasarkan segmen jenis layanan
/// (Antar / Jemput / Ambil di Toko) yang dipilih pengguna.
class JadwalViewModel extends ChangeNotifier {
  JadwalViewModel(this._repo);

  final JadwalRepository _repo;

  List<JadwalLaundry> _all = const [];
  JenisLayanan _segment = JenisLayanan.antar;
  bool _isLoading = false;
  String? _error;

  /// Segmen jenis layanan yang sedang aktif.
  JenisLayanan get segment => _segment;

  /// Daftar jadwal yang cocok dengan segmen aktif.
  List<JadwalLaundry> get filtered =>
      _all.where((j) => j.jenisLayanan == _segment).toList(growable: false);

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Mengganti segmen aktif lalu memberi tahu pendengar.
  void setSegment(JenisLayanan value) {
    if (_segment == value) return;
    _segment = value;
    notifyListeners();
  }

  /// Memuat seluruh jadwal dari repository.
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
