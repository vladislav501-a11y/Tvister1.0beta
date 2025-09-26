import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'services/subscription_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  runApp(TvisterApp(storage: storage));
}

class TvisterApp extends StatelessWidget {
  final StorageService storage;
  const TvisterApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionService(storage)),
      ],
      child: MaterialApp(
        title: 'Tvister',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const AuthPage(),
        routes: {
          '/home': (_) => const HomePage(),
        },
      ),
    );
  }
}
