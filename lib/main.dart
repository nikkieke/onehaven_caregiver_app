import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onehaven_caregiver_app/core/cache_service.dart';
import 'package:onehaven_caregiver_app/core/router.dart';
import 'package:onehaven_caregiver_app/core/shared_prefs.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(MembersListAdapter());
  await CacheService.instance.init();
  await SharedPrefHandler.instance.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'OneHaven CareGiver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
    );
  }
}
