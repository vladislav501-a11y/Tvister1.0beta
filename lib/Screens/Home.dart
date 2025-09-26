import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../services/subscription_service.dart';
import '../widgets/story_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _msgCtrl = TextEditingController();
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    final subs = Provider.of<SubscriptionService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tvister — v1.0.0-beta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              // Профиль — сменить ник/подписку
              final res = await showDialog<bool>(
                context: context,
                builder: (_) => _ProfileDialog(),
              );
              if (res == true) setState(() {});
            },
          )
        ],
      ),
      body: Column(
        children: [
          // stories bar
          SizedBox(height: 110, child: StoryWidget()),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (_, i) => ListTile(title: Text(messages[i])),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _handleAttach(subs),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: const InputDecoration(hintText: 'Написать сообщение...'),
                      onSubmitted: (_) => _send(subs),
                    ),
                  ),
                ),
                IconButton(onPressed: () => _send(subs), icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Tvister Leto — 200 ₽/мес'),
        icon: const Icon(Icons.star),
        onPressed: () => _buySubscriptionFlow(context),
      ),
    );
  }

  void _send(SubscriptionService subs) {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    // Если сообщение обозначает использование ИИ или файл >5GB, проверяем подписку
    final wantsAi = text.startsWith('/ai ');
    if (wantsAi && !subs.isSubscribed) {
      _gotoAdminChat(context);
      return;
    }

    setState(() {
      messages.add('${subs.username}: $text');
      _msgCtrl.clear();
    });
  }

  Future<void> _handleAttach(SubscriptionService subs) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final f = result.files.single;
    // If file too large (>5GB) block without subscription (we check size if available)
    final size = f.size; // bytes (may be 0 if unknown)
    final fiveGb = 5 * 1024 * 1024 * 1024;
    if (size != 0 && size > fiveGb && !subs.isSubscribed) {
      _gotoAdminChat(context);
      return;
    }

    setState(() {
      messages.add('${subs.username} sent file: ${f.name}');
    });
  }

  void _gotoAdminChat(BuildContext ctx) {
    // Redirect to DM with @tvister01
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => AdminChatPage()));
  }

  Future<void> _buySubscriptionFlow(BuildContext ctx) async {
    // In this repo we don't process payments. Instead we redirect to @tvister01 as requested
    _gotoAdminChat(ctx);
  }
}

class _ProfileDialog extends StatefulWidget {
  @override
  State<_ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<_ProfileDialog> {
  final TextEditingController _nickCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final subs = Provider.of<SubscriptionService>(context);
    _nickCtrl.text = subs.username;
    return AlertDialog(
      title: const Text('Профиль'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nickCtrl, decoration: const InputDecoration(labelText: 'Ник')),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Подписка: '),
            Text(subs.isSubscribed ? 'Активна' : 'Неактивна'),
          ])
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Закрыть')),
        TextButton(
          onPressed: () async {
            await subs.setUsername(_nickCtrl.text.trim());
            Navigator.pop(context, true);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class AdminChatPage extends StatefulWidget {
  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final TextEditingController _ctrl = TextEditingController();
  final List<String> msgs = [
    'Вы перешли в личные сообщения с @tvister01. Напишите здесь, чтобы договориться о подписке.'
  ];

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      msgs.add('Вы: $t');
      msgs.add('@tvister01: (авто) Спасибо! Чтобы оформить подписку, напишите "Оплатить" и следуйте инструкциям.');
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('@tvister01')),
      body: Column(
        children: [
          Expanded(child: ListView.builder(itemCount: msgs.length, itemBuilder: (_, i) => ListTile(title: Text(msgs[i])))),
          SafeArea(
            child: Row(children: [
              Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _ctrl))),
              IconButton(icon: const Icon(Icons.send), onPressed: _send)
            ]),
          )
        ],
      ),
    );
  }
}
