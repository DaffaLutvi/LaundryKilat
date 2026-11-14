/// Service yang mensimulasikan pengambilan data dari server jauh.
///
/// Setiap metode memberi jeda dengan [Future.delayed] agar pola pemuatan
/// (loading) terlihat seperti aplikasi nyata. Data yang dikembalikan berupa
/// `List<Map<String, dynamic>>` (data mentah) yang kemudian diubah menjadi
/// model oleh repository.
///
/// Karena metode tidak bersifat `final`, service ini dapat diturunkan di test
/// untuk mengganti data yang dikembalikan.
class LaundryService {
  const LaundryService();

  /// Mengambil daftar jadwal antar/jemput.
  Future<List<Map<String, dynamic>>> getJadwal() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _jadwalData;
  }

  /// Mengambil daftar order cucian.
  Future<List<Map<String, dynamic>>> getCucian() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _cucianData;
  }

  /// Mengambil daftar info, promo, dan pengumuman.
  Future<List<Map<String, dynamic>>> getInfo() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _infoData;
  }
}

const List<Map<String, dynamic>> _jadwalData = [
  {
    'id': 'J1',
    'namaPelanggan': 'Andi',
    'jenisLayanan': 'Antar',
    'hari': 'Senin',
    'waktu': '08.00',
    'alamat': 'Jl. Mawar No. 12',
    'beratKg': 3.0,
  },
  {
    'id': 'J2',
    'namaPelanggan': 'Budi',
    'jenisLayanan': 'Jemput',
    'hari': 'Senin',
    'waktu': '10.00',
    'alamat': 'Jl. Melati No. 5',
    'beratKg': 2.5,
  },
  {
    'id': 'J3',
    'namaPelanggan': 'Citra',
    'jenisLayanan': 'Ambil di Toko',
    'hari': 'Senin',
    'waktu': '13.00',
    'alamat': '-',
    'beratKg': 1.0,
  },
  {
    'id': 'J4',
    'namaPelanggan': 'Dewi',
    'jenisLayanan': 'Antar',
    'hari': 'Selasa',
    'waktu': '09.00',
    'alamat': 'Jl. Anggrek No. 8',
    'beratKg': 5.0,
  },
  {
    'id': 'J5',
    'namaPelanggan': 'Eka',
    'jenisLayanan': 'Jemput',
    'hari': 'Rabu',
    'waktu': '11.00',
    'alamat': 'Jl. Kenanga No. 3',
    'beratKg': 4.2,
  },
  {
    'id': 'J6',
    'namaPelanggan': 'Fajar',
    'jenisLayanan': 'Antar',
    'hari': 'Kamis',
    'waktu': '08.30',
    'alamat': 'Jl. Dahlia No. 9',
    'beratKg': 6.0,
  },
  {
    'id': 'J7',
    'namaPelanggan': 'Gita',
    'jenisLayanan': 'Ambil di Toko',
    'hari': 'Jumat',
    'waktu': '14.00',
    'alamat': '-',
    'beratKg': 2.0,
  },
  {
    'id': 'J8',
    'namaPelanggan': 'Hadi',
    'jenisLayanan': 'Jemput',
    'hari': 'Sabtu',
    'waktu': '09.30',
    'alamat': 'Jl. Tulip No. 7',
    'beratKg': 3.5,
  },
  {
    'id': 'J9',
    'namaPelanggan': 'Indah',
    'jenisLayanan': 'Antar',
    'hari': 'Minggu',
    'waktu': '10.00',
    'alamat': 'Jl. Lavender No. 1',
    'beratKg': 2.8,
  },
];

const List<Map<String, dynamic>> _cucianData = [
  {
    'id': 'C1',
    'nama': 'Andi',
    'jenis': 'Cuci Setrika',
    'beratKg': 3.0,
    'isDone': false,
    'tanggal': '2026-11-01',
  },
  {
    'id': 'C2',
    'nama': 'Budi',
    'jenis': 'Cuci Kering',
    'beratKg': 2.5,
    'isDone': false,
    'tanggal': '2026-11-01',
  },
  {
    'id': 'C3',
    'nama': 'Citra',
    'jenis': 'Cuci Lipat',
    'beratKg': 1.0,
    'isDone': false,
    'tanggal': '2026-11-02',
  },
  {
    'id': 'C4',
    'nama': 'Dewi',
    'jenis': 'Cuci Setrika',
    'beratKg': 5.0,
    'isDone': true,
    'tanggal': '2026-10-31',
  },
  {
    'id': 'C5',
    'nama': 'Eka',
    'jenis': 'Cuci Kering',
    'beratKg': 4.2,
    'isDone': false,
    'tanggal': '2026-11-02',
  },
  {
    'id': 'C6',
    'nama': 'Fajar',
    'jenis': 'Setrika Aja',
    'beratKg': 6.0,
    'isDone': true,
    'tanggal': '2026-10-30',
  },
];

const List<Map<String, dynamic>> _infoData = [
  {
    'id': 'I1',
    'judul': 'Promo Akhir Pekan',
    'deskripsi': 'Diskon 20% untuk cucian sabtu-minggu.',
    'kategori': 'Promo',
    'penting': true,
    'tanggal': '2026-11-01',
  },
  {
    'id': 'I2',
    'judul': 'Paket Hemat Kilauan',
    'deskripsi': 'Cucian 5kg hanya Rp30.000.',
    'kategori': 'Paket',
    'penting': false,
    'tanggal': '2026-11-01',
  },
  {
    'id': 'I3',
    'judul': 'Libur Sementara',
    'deskripsi': 'Toko tutup tanggal 10 November.',
    'kategori': 'Pengumuman',
    'penting': true,
    'tanggal': '2026-11-03',
  },
  {
    'id': 'I4',
    'judul': 'Promo Member',
    'deskripsi': 'Cashback 10% tiap order member.',
    'kategori': 'Promo',
    'penting': false,
    'tanggal': '2026-11-02',
  },
  {
    'id': 'I5',
    'judul': 'Paket Express',
    'deskripsi': 'Cucian 1kg selesai dalam 6 jam.',
    'kategori': 'Paket',
    'penting': false,
    'tanggal': '2026-11-02',
  },
  {
    'id': 'I6',
    'judul': 'Jam Operasional',
    'deskripsi': 'Toko buka 07.00-21.00 setiap hari.',
    'kategori': 'Pengumuman',
    'penting': false,
    'tanggal': '2026-11-01',
  },
];
