import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

class SettingsOverlay extends StatelessWidget {
  const SettingsOverlay({super.key});

  // Maps a language code to its display name.
  String _langName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'war':
        return 'Waray';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read lang once for strings — this widget itself only needs lang.
    // Each toggle reads its own value via context.select so only that
    // specific tile rebuilds when its value changes.
    final lang = context.select<AppProvider, String>((p) => p.language);
    final provider = context.read<AppProvider>();

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
          // ── Follow System Theme ───────────────────────────────
          // Allows the app to automatically sync with device settings
          Builder(
            builder: (context) {
              final followSystem = context.select<AppProvider, bool>(
                (p) => p.followSystemTheme,
              );
              return SwitchListTile(
                secondary: const Icon(Icons.brightness_4_rounded),
                title: Text(AppStrings.get('follow_system_theme', lang)),
                subtitle: Text(
                  AppStrings.get('follow_system_theme_desc', lang),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: followSystem,
                onChanged: context.read<AppProvider>().toggleFollowSystemTheme,
              );
            },
          ),
          const Divider(height: 1),

          // ── Dark Mode ─────────────────────────────────────────
          // Manual dark mode toggle (only active when not following system)
          Builder(
            builder: (context) {
              final isDark = context.select<AppProvider, bool>(
                (p) => p.isDarkMode,
              );
              final followSystem = context.select<AppProvider, bool>(
                (p) => p.followSystemTheme,
              );
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode_rounded),
                title: Text(AppStrings.get('dark_mode', lang)),
                subtitle: followSystem
                    ? Text(
                        AppStrings.get('dark_mode_system_override', lang),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : null,
                value: isDark,
                onChanged: followSystem
                    ? null
                    : context.read<AppProvider>().toggleDarkMode,
              );
            },
          ),
          const Divider(height: 1),

          // ── Notifications ─────────────────────────────────────
          Builder(
            builder: (context) {
              final notifs = context.select<AppProvider, bool>(
                (p) => p.notificationsEnabled,
              );
              return SwitchListTile(
                secondary: const Icon(Icons.notifications_rounded),
                title: Text(AppStrings.get('notifications', lang)),
                value: notifs,
                onChanged: context.read<AppProvider>().toggleNotifications,
              );
            },
          ),
          const Divider(height: 1),

          // ── Language ──────────────────────────────────────────
          // PopupMenuButton replaces DropdownButton so we can force
          // the menu to always open downward via the offset parameter.
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(AppStrings.get('language', lang)),
            trailing: PopupMenuButton<String>(
              // A positive Y offset pushes the menu below the button.
              offset: const Offset(0, 40),
              onSelected: (v) => context.read<AppProvider>().setLanguage(v),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'en',
                  child: Text(
                    'English',
                    style: TextStyle(
                      fontWeight: lang == 'en'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'war',
                  child: Text(
                    'Waray',
                    style: TextStyle(
                      fontWeight: lang == 'war'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                // ─────────────────────────────────────────────────
                // ADD LANGUAGE OPTION HERE. Example:
                // PopupMenuItem(
                //   value: 'ceb',
                //   child: Text(
                //     'Cebuano',
                //     style: TextStyle(
                //       fontWeight: lang == 'ceb'
                //           ? FontWeight.bold
                //           : FontWeight.normal,
                //     ),
                //   ),
                // ),
                // ─────────────────────────────────────────────────
              ],
              // Custom child shows the current language name with a
              // dropdown arrow, matching the look of the old widget.
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_langName(lang), style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          // ── Exit ─────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: Colors.red),
            title: Text(
              AppStrings.get('exit', lang),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _confirmExit(context, lang),
          ),
          const Divider(height: 1),

          // ── Version ──────────────────────────────────────────
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
