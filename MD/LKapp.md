# Laundry Kilat

Aplikasi Flutter manajemen usaha **laundry kiloan** dengan arsitektur berlapis (View, ViewModel, Repository, Service) sesuai panduan resmi Flutter.

> Tugas Pemrograman Perangkat Mobile (IF31033), Program Studi Teknik Informatika, Universitas Nusa Putra.
> Nama: \*\*Daffa Lutvi Mahendra\*\* · NIM: `<20240040142>`

\---

## Tema dan Alasan Memilih

Tema yang dipilih adalah **laundry kiloan**. Usaha laundry punya alur kerja yang jelas dan berulang: jadwal antar-jemput per hari, cucian yang harus diproses, serta info promo untuk pelanggan. Ketiga hal ini cocok dipetakan ke tiga jenis data pada tugas, dan jarang dipilih teman sekelas dibanding tema umum seperti kedai kopi.

<!-- Sesuaikan 2-3 kalimat di atas dengan alasan pribadimu (misalnya ada laundry di sekitar rumah). -->

\---

## Pemetaan Data

|Jenis data|Model|Isi|Dipakai di|
|-|-|-|-|
|Data utama|`JadwalLaundry`|Jadwal antar/jemput per jenis layanan dan hari|Beranda, Jadwal|
|Data aksi|`CucianOrder`|Order cucian yang bisa dicentang selesai (`isDone`)|Beranda, Checklist|
|Data informasi|`InfoLaundry`|Promo, paket, dan pengumuman|Info \& Promo|

Semua field model bersifat `final` dan memiliki `fromJson()`. `CucianOrder` juga memiliki `copyWith()`.

\---

## Fitur per Tab

|Tab|Fungsi|
|-|-|
|**Beranda**|Gabungan data dari dua repository: jadwal untuk hari ini dan order cucian yang belum selesai.|
|**Jadwal**|Daftar jadwal dengan `SegmentedButton` 3 segmen: Antar, Jemput, Ambil di Toko.|
|**Checklist**|Order cucian dengan `CheckboxListTile`. Item yang dicentang pindah ke bagian *Selesai*. Tab ini memiliki badge jumlah order yang belum selesai.|
|**Info \& Promo**|Fitur buatan sendiri (lihat bagian di bawah).|

### Fitur Buatan Sendiri: Info \& Promo

Halaman kartu pengumuman untuk pelanggan laundry. Pengguna dapat menyaring info lewat chip kategori (**Semua / Promo / Paket / Pengumuman**), dan info yang ditandai penting diberi label **Penting**. Logika penyaringan berada di `InfoPromoViewModel`, bukan di widget, sehingga mudah diuji tanpa layar.

\---

## Arsitektur

```
View  <->  ViewModel  <->  Repository  <->  Service
(UI layer)                 (Data layer)
```

|Komponen|Tugas|Contoh file|
|-|-|-|
|View|Menampilkan data dan meneruskan aksi pengguna|`home\_screen.dart`|
|ViewModel|Menyiapkan data siap tampil, `isLoading`, `error`, `load()`|`home\_view\_model.dart`|
|Repository|Sumber kebenaran data, menyimpan cache, mengubah Map menjadi model|`cucian\_repository.dart`|
|Service|Mengambil data mentah (simulasi server dengan `Future.delayed`)|`laundry\_service.dart`|

Poin penting:

* `CucianRepository` adalah `ChangeNotifier`, sehingga Beranda dan badge tab Checklist ikut berubah saat item dicentang.
* Semua Service dan Repository didaftarkan di `config/dependencies.dart` memakai `MultiProvider`, lalu diambil dengan `context.read()`.
* Setiap halaman punya satu ViewModel (`ChangeNotifier`) dan ditampilkan memakai `ListenableBuilder`.

### Struktur Folder

```
lib/
├── main.dart
├── app.dart
├── config/
│   └── dependencies.dart
├── domain/
│   └── models/
│       ├── jadwal\_laundry.dart
│       ├── cucian\_order.dart
│       └── info\_laundry.dart
├── data/
│   ├── services/
│   │   └── laundry\_service.dart
│   └── repositories/
│       ├── jadwal\_repository.dart
│       ├── cucian\_repository.dart
│       └── info\_repository.dart
└── ui/
    ├── core/
    ├── shell/
    │   └── app\_shell.dart
    ├── home/
    ├── jadwal/
    ├── checklist/
    └── info\_promo/
        ├── info\_promo\_view\_model.dart
        └── info\_promo\_screen.dart
test/
└── info\_promo\_view\_model\_test.dart
```

\---

## Cara Menjalankan

```bash
git clone <url-repository>
cd laundry\_cepat
flutter pub get
flutter run
```

Menjalankan test:

```bash
flutter test
```

\---

## Screenshot

### Setiap Tab

|Beranda|Jadwal|
|-|-|
|!\[Beranda](screenshots/beranda.png)|!\[Jadwal](screenshots/jadwal.png)|

|Checklist|Info \& Promo|
|-|-|
|!\[Checklist](screenshots/checklist.png)|!\[Info \& Promo](screenshots/info\_promo.png)|

### Beranda Sebelum dan Sesudah Item Dicentang

|Sebelum|Sesudah|
|-|-|
|!\[Beranda sebelum](screenshots/beranda\_sebelum.png)|!\[Beranda sesudah](screenshots/beranda\_sesudah.png)|

\---

## Hasil `flutter test`

```
<tempel output flutter test di sini, contoh: 00:02 +3: All tests passed!>
```

!\[Hasil flutter test](screenshots/flutter\_test.png)

\---

## Teknologi

* Flutter (Material 3)
* Package `provider` untuk dependency injection dan state management
* Arsitektur MVVM mengikuti [docs.flutter.dev/app-architecture](https://docs.flutter.dev/app-architecture)

