import 'package:flutter/foundation.dart';

/// Data aksi: order cucian yang bisa dicentang selesai.
///
/// Field [isDone] menentukan apakah cucian sudah selesai. Selain [fromJson],
/// model ini juga memiliki [copyWith] agar [CucianRepository] dapat membuat
/// salinan baru saat status selesai diubah.
@immutable
class CucianOrder {
  const CucianOrder({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.beratKg,
    required this.isDone,
    required this.tanggal,
  });

  /// Identifier unik order.
  final String id;

  /// Nama pelanggan pemilik cucian.
  final String nama;

  /// Jenis layanan cucian (Cuci Setrika, Cuci Kering, dst.).
  final String jenis;

  /// Berat cucian dalam kilogram.
  final double beratKg;

  /// `true` jika cucian sudah selesai diproses.
  final bool isDone;

  /// Tanggal order dalam format yyyy-MM-dd.
  final String tanggal;

  /// Membuat salinan model dengan sebagian field diganti.
  CucianOrder copyWith({
    String? id,
    String? nama,
    String? jenis,
    double? beratKg,
    bool? isDone,
    String? tanggal,
  }) {
    return CucianOrder(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      beratKg: beratKg ?? this.beratKg,
      isDone: isDone ?? this.isDone,
      tanggal: tanggal ?? this.tanggal,
    );
  }

  /// Membuat model dari data mentah hasil [Map] service.
  factory CucianOrder.fromJson(Map<String, dynamic> json) {
    return CucianOrder(
      id: json['id'] as String,
      nama: json['nama'] as String,
      jenis: json['jenis'] as String,
      beratKg: (json['beratKg'] as num).toDouble(),
      isDone: json['isDone'] as bool? ?? false,
      tanggal: json['tanggal'] as String,
    );
  }
}
