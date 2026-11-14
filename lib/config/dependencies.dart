import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/cucian_repository.dart';
import '../data/repositories/info_repository.dart';
import '../data/repositories/jadwal_repository.dart';
import '../data/services/laundry_service.dart';

/// Mendaftarkan seluruh Service dan Repository ke [MultiProvider].
///
/// Daftar ini diberikan ke `MultiProvider` pada [MaterialApp] sehingga seluruh
/// layar dapat mengambil dependency memakai `context.read<T>()`. [CucianRepository]
/// sengaja dipakai sebagai [ChangeNotifierProvider] agar perubahannya bisa
/// dipantau oleh Beranda dan badge tab Checklist.
final List<SingleChildWidget> providerDependencies = [
  Provider<LaundryService>(create: (_) => const LaundryService()),
  Provider<JadwalRepository>(
    create: (context) => JadwalRepository(context.read<LaundryService>()),
  ),
  ChangeNotifierProvider<CucianRepository>(
    create: (context) => CucianRepository(context.read<LaundryService>()),
  ),
  Provider<InfoRepository>(
    create: (context) => InfoRepository(context.read<LaundryService>()),
  ),
];
