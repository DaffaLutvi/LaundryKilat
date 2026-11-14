import 'package:flutter/foundation.dart';

import '../../data/repositories/cucian_repository.dart';
import '../../domain/models/cucian_order.dart';

/// ViewModel untuk tab Checklist.
///
/// Meneruskan data dari [CucianRepository] dan memantau perubahannya. Karena
/// repository adalah [ChangeNotifier], daftar "Belum Selesai" dan "Selesai"
/// otomatis tersusun ulang saat sebuah item dicentang.
class ChecklistViewModel extends ChangeNotifier {
  ChecklistViewModel(this._repo) {
    _repo.addListener(_onChanged);
  }

  final CucianRepository _repo;

  List<CucianOrder> get belumSelesai => _repo.belumSelesai;
  List<CucianOrder> get selesai => _repo.selesai;
  int get jumlahBelumSelesai => _repo.jumlahBelumSelesai;

  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Membalik status selesai order.
  void toggleSelesai(String id) => _repo.toggleSelesai(id);

  /// Memuat daftar order dari repository.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repo.load();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onChanged() => notifyListeners();

  @override
  void dispose() {
    _repo.removeListener(_onChanged);
    super.dispose();
  }
}
