import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

class SettingsOverlay extends StatelessWidget {
  const SettingsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final lang = provider.language;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => provider.setOverlay('none'),
        ),
        title: Text(AppStrings.get('settings', lang)),
      ),
      body: ListView(
        children: [
          // ── Dark Mode ────────────────────────────────
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_rounded),
            title: Text(AppStrings.get('dark_mode', lang)),
            value: provider.isDarkMode,
            onChanged: provider.toggleDarkMode,
          ),
          const Divider(height: 1),

          // ── Notifications ─────────────────────────────
          SwitchListTile(
            secondary: const Icon(Icons.notifications_rounded),
            title: Text(AppStrings.get('notifications', lang)),
            value: provider.notificationsEnabled,
            onChanged: provider.toggleNotifications,
          ),
          const Divider(height: 1),

          // ── Language switcher ─────────────────────────
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(AppStrings.get('language', lang)),
            trailing: DropdownButton<String>(
              value: provider.language,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(10),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'war', child: Text('Waray')),
                // ─────────────────────────────────────────────────────────
                // ADD YOUR LOCAL LANGUAGE OPTION HERE. Example:
                // DropdownMenuItem(value: 'ceb', child: Text('Cebuano')),
                // Make sure translations exist in lib/utils/strings.dart.
                // ─────────────────────────────────────────────────────────
              ],
              onChanged: (v) {
                if (v != null) provider.setLanguage(v);
              },
            ),
          ),
          const Divider(height: 1),

          // ── Exit ─────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: Colors.red),
            title: Text(
              AppStrings.get('exit', lang),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _confirmExit(context, lang),
          ),
          const Divider(height: 1),

          // ── Version ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              AppStrings.get('version', lang),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmExit(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.get('exit', lang)),
        content: Text(AppStrings.get('exit_confirm', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.get('no', lang)),
          ),
          FilledButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(AppStrings.get('yes', lang)),
          ),
        ],
      ),
    );
  }
}
