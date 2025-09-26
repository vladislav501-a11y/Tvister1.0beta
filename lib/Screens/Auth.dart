import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/subscription_service.dart';
import '../services/storage_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final storage = (Provider.of<SubscriptionService>(context, listen: false))._storage;
    // If username exists — go to home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storage.username != null && storage.username!.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subs = Provider.of<SubscriptionService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Tvister — Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _ctrl,
              decoration: const InputDecoration(labelText: 'Username (например @tvister01)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final name = _ctrl.text.trim();
                if (name.isEmpty) return;
                await subs.setUsername(name);
                if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Продолжить'),
            ),
          ],
        ),
      ),
    );
  }
}
