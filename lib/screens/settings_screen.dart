import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/security_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('App Lock'),
            subtitle: const Text('Secure app with biometric authentication'),
            trailing: Switch(
              value: context.watch<SecurityProvider>().isAppLockEnabled,
              onChanged: (value) =>
                  context.read<SecurityProvider>().toggleAppLock(value),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              // Show about dialog
              showAboutDialog(
                context: context,
                applicationName: 'Secure Notes',
                applicationVersion: '1.0.0',
                applicationLegalese: '©2024 Your Name',
              );
            },
          ),
        ],
      ),
    );
  }
}
