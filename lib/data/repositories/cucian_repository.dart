import 'package:flutter/foundation.dart';

import '../../domain/models/cucian_order.dart';
import '../services/laundry_service.dart';

/// Repository [ChangeNotifier] sumber kebenaran data cucian.
///
/// Karena merupakan [ChangeNotifier], Beranda dan badge tab Checklist akan
/// otomatis terbarui saat sebuah item dicentang selesai.
class CucianRepository extends ChangeNotifier {
  CucianRepository(this._service);

  final LaundryService _service;

  List<CucianOrder> _cache = const [];
  bool _loaded = false;

  /// Salinan daftar seluruh order (tidak boleh diubah dari luar).
  List<CucianOrder> get cache => List.unmodifiable(_cache);

  /// Daftar order yang belum selesai.
  List<CucianOrder> get belumSelesai =>
      _cache.where((o) => !o.isDone).toList(growable: false);

  /// Daftar order yang sudah selesai.
  List<CucianOrder> get selesai =>
      _cache.where((o) => o.isDone).toList(growable: false);

  /// Jumlah order yang belum selesai. Dipakai untuk badge tab Checklist.
  int get jumlahBelumSelesai => _cache.where((o) => !o.isDone).length;

  /// Memuat daftar order. Mengembalikan cache bila sudah pernah dimuat,
  /// kecuali [force] `true`.
  Future<List<CucianOrder>> load({bool force = false}) async {
    if (_loaded && !force) return _cache;
    final raw = await _service.getCucian();
    _cache = raw.map(CucianOrder.fromJson).toList(growable: false);
    _loaded = true;
    notifyListeners();
    return _cache;
  }

  /// Membalik status selesai order dengan [id] lalu memberi tahu pendengar.
  void toggleSelesai(String id) {
    final index = _cache.indexWhere((o) => o.id == id);
    if (index == -1) return;
    final order = _cache[index];
    _cache[index] = order.copyWith(isDone: !order.isDone);
    notifyListeners();
  }
}
