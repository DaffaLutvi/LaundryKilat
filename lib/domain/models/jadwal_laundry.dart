import 'package:flutter/foundation.dart';

/// Jenis layanan penjadwalan laundry.
///
/// Dipakai sebagai segmen pada tab Jadwal (Antar, Jemput, Ambil di Toko).
enum JenisLayanan { antar, jemput, ambilDiToko }

const _jenisLayananLabel = <JenisLayanan, String>{
  JenisLayanan.antar: 'Antar',
  JenisLayanan.jemput: 'Jemput',
  JenisLayanan.ambilDiToko: 'Ambil di Toko',
};

/// Ekstensi untuk mendapatkan label teks dari [JenisLayanan].
extension JenisLayananX on JenisLayanan {
  String get label => _jenisLayananLabel[this]!;
}

/// Data utama: jadwal antar/jemput per jenis layanan dan hari.
///
/// Semua field bersifat [final] (immutable) dan model memiliki [fromJson].
@immutable
class JadwalLaundry {
  const JadwalLaundry({
    required this.id,
    required this.namaPelanggan,
    required this.jenisLayanan,
    required this.hari,
    required this.waktu,
    required this.alamat,
    this.beratKg = 0,
  });

  /// Identifier unik jadwal.
  final String id;

  /// Nama pelanggan yang menjadwalkan layanan.
  final String namaPelanggan;

  /// Jenis layanan (Antar / Jemput / Ambil di Toko).
  final JenisLayanan jenisLayanan;

  /// Hari pelaksanaan (Senin..Minggu).
  final String hari;

  /// Waktu pelaksanaan dalam format HH.mm.
  final String waktu;

  /// Alamat penjemputan/pengantaran. Kosong untuk "Ambil di Toko".
  final String alamat;

  /// Estimasi berat cucian dalam kilogram.
  final double beratKg;

  /// Membuat model dari data mentah hasil [Map] service.
  factory JadwalLaundry.fromJson(Map<String, dynamic> json) {
    return JadwalLaundry(
      id: json['id'] as String,
      namaPelanggan: json['namaPelanggan'] as String,
      jenisLayanan: _parseJenisLayanan(json['jenisLayanan'] as String),
      hari: json['hari'] as String,
      waktu: json['waktu'] as String,
      alamat: json['alamat'] as String,
      beratKg: (json['beratKg'] as num?)?.toDouble() ?? 0,
    );
  }
}

JenisLayanan _parseJenisLayanan(String value) {
  switch (value) {
    case 'Jemput':
      return JenisLayanan.jemput;
    case 'Ambil di Toko':
      return JenisLayanan.ambilDiToko;
    case 'Antar':
    default:
      return JenisLayanan.antar;
  }
}
