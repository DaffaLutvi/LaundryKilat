import 'package:flutter/foundation.dart';

/// Kategori info laundry untuk fitur Info & Promo.
enum KategoriInfo { promo, paket, pengumuman }

const _kategoriInfoLabel = <KategoriInfo, String>{
  KategoriInfo.promo: 'Promo',
  KategoriInfo.paket: 'Paket',
  KategoriInfo.pengumuman: 'Pengumuman',
};

/// Ekstensi untuk mendapatkan label teks dari [KategoriInfo].
extension KategoriInfoX on KategoriInfo {
  String get label => _kategoriInfoLabel[this]!;
}

/// Data informasi: promo, paket, dan pengumuman untuk pelanggan laundry.
///
/// Info yang ditandai penting akan diberi label "Penting" pada layar.
@immutable
class InfoLaundry {
  const InfoLaundry({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.penting,
    required this.tanggal,
  });

  /// Identifier unik info.
  final String id;

  /// Judul singkat info.
  final String judul;

  /// Penjelasan isi info.
  final String deskripsi;

  /// Kategori info (Promo / Paket / Pengumuman).
  final KategoriInfo kategori;

  /// `true` jika info penting dan perlu ditandai.
  final bool penting;

  /// Tanggal info dalam format yyyy-MM-dd.
  final String tanggal;

  /// Membuat model dari data mentah hasil [Map] service.
  factory InfoLaundry.fromJson(Map<String, dynamic> json) {
    return InfoLaundry(
      id: json['id'] as String,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      kategori: _parseKategoriInfo(json['kategori'] as String),
      penting: json['penting'] as bool? ?? false,
      tanggal: json['tanggal'] as String,
    );
  }
}

KategoriInfo _parseKategoriInfo(String value) {
  switch (value) {
    case 'Paket':
      return KategoriInfo.paket;
    case 'Pengumuman':
      return KategoriInfo.pengumuman;
    case 'Promo':
    default:
      return KategoriInfo.promo;
  }
}
