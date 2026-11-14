import 'package:flutter/foundation.dart';

import '../../data/repositories/cucian_repository.dart';
import '../../data/repositories/jadwal_repository.dart';
import '../../domain/models/cucian_order.dart';
import '../../domain/models/jadwal_laundry.dart';

/// ViewModel untuk tab Beranda.
///
/// Menyiapkan gabungan data dari dua repository: jadwal untuk hari ini dan
/// order cucian yang belum selesai. Karena memantau [CucianRepository], daftar
/// cucian di Beranda otomatis berubah saat item dicentang dari tab lain.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._jadwalRepo, this._cucianRepo) {
    _cucianRepo.addListener(_onCucianChanged);
  }

  final JadwalRepository _jadwalRepo;
  final CucianRepository _cucianRepo;

  List<JadwalLaundry> _jadwalHariIni = const [];
  List<CucianOrder> _belumSelesai = const [];
  bool _isLoading = false;
  String? _error;

  List<JadwalLaundry> get jadwalHariIni => _jadwalHariIni;
  List<CucianOrder> get belumSelesai => _belumSelesai;
  String get namaHariIni => _jadwalRepo.namaHariIni;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Memuat jadwal hari ini dan daftar cucian sekaligus.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.wait([
        _jadwalRepo.getJadwalHariIni().then((value) => _jadwalHariIni = value),
        _cucianRepo.load(),
      ]);
      _belumSelesai = _cucianRepo.belumSelesai;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Membalik status selesai order (dipanggil dari checkbox di Beranda).
  void toggleSelesai(String id) => _cucianRepo.toggleSelesai(id);

  /// Dipanggil ketika [CucianRepository] berubah agar Beranda ikut membarui.
  void _onCucianChanged() {
    _belumSelesai = _cucianRepo.belumSelesai;
    notifyListeners();
  }

  @override
  void dispose() {
    _cucianRepo.removeListener(_onCucianChanged);
    super.dispose();
  }
}
