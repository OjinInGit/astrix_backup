// ============================================================
// LOCALIZATION — Astrix DVC
// ============================================================
// HOW TO ADD YOUR LOCAL LANGUAGE:
//
//  1. Add a new key inside '_strings' using your language code
//     as the key (e.g., 'ceb' for Cebuano, 'fil' for Filipino).
//     Copy all keys from the 'en' block and translate them.
//
//  2. In lib/overlays/settings_overlay.dart, find the comment
//     marked "ADD LANGUAGE OPTION HERE" and add a DropdownMenuItem
//     with your language code and display name.
//
//  3. AppProvider.setLanguage('your_code') is already wired —
//     no other changes needed.
// ============================================================

class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'app_title': 'Astrix DVC',
      'app_subtitle': 'by Astrix Systems',
      'water_params': 'Water Parameters',
      'dissolved_oxygen': 'DO',
      'ph': 'pH',
      'temperature': 'Water Temp.',
      'turbidity': 'Turbidity',
      'water_quality': 'Water Quality',
      'update_logs': 'Update Logs',
      'controls': 'Controls',
      'manual': 'Manual',
      'settings': 'Settings',
      'exit': 'Exit',
      'device_config': 'Device Configuration and Controls',
      'feed_amount': 'Feed Amount (kg)',
      'feeding_schedules': 'Feeding Schedules',
      'schedule_note': 'Good water: all 6  •  Average: 3  •  Bad: 1–2',
      'save_changes': 'Save Changes',
      'back': 'Back',
      'user_manual': 'User Manual',
      'setup': 'Setup',
      'troubleshooting': 'Troubleshooting',
      'maintenance': 'Maintenance',
      'reach_devs': 'Reach out to the devs!',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'language': 'Language',
      'version': 'Version 1.4.4',
      'exit_confirm': 'Do you really want to exit the application?',
      'yes': 'Yes',
      'no': 'No',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'no_logs': 'No logs yet.',
      'saved': 'Configuration saved!',
      // ← ADD MORE STRING KEYS HERE AS NEEDED
    },
    'war': {
      'app_title': 'Astrix DVC',
      'app_subtitle': 'by Astrix Systems',
      'water_params': 'Water Parameters',
      'dissolved_oxygen': 'DO',
      'ph': 'pH',
      'temperature': 'Water Temp.',
      'turbidity': 'Turbidity',
      'water_quality': 'Kalidad sa Tubig',
      'update_logs': 'Mga Updates',
      'controls': 'Controls',
      'manual': 'Manual',
      'settings': 'Settings',
      'exit': 'Exit',
      'device_config': 'Device Configuration and Controls',
      'feed_amount': 'Kantidad hit tubong (kg)',
      'feeding_schedules': 'Schedule hit pagtubong',
      'schedule_note': 'Maupay: all 6  •  Normal: 3  •  Maraot: 1–2',
      'save_changes': 'I-save an gipanbalyo',
      'back': 'Balik',
      'user_manual': 'User Manual',
      'setup': 'Setup',
      'troubleshooting': 'Pag-ayad',
      'maintenance': 'Pag-mentenar',
      'reach_devs': 'Pagpaabot ha mga devs!',
      'dark_mode': 'Pagpasirom',
      'notifications': 'Mga Pasabot',
      'language': 'Lengwahe',
      'version': 'Version 1.4.4',
      'exit_confirm': 'Ma-exit kat application? Maduro gad? Sure na? Weh?',
      'yes': 'Oo',
      'no': 'Diri',
      'connected': 'Konektado',
      'disconnected': 'Nautod',
      'no_logs': 'Waray pa Updates',
      'saved': 'Nasave an giblayo!',
    },
    // ← ADD YOUR LOCAL LANGUAGE HERE. Example:
    // 'war': {
    //   'app_title': 'Astrix DVC',
    //   'app_subtitle': 'ni Astrix Systems',
    //   'controls': 'Kontrol',
    //   'exit_confirm': 'Gusto ba gayud nimo mogawas?',
    //   ... (all keys above must be present)
    // },
  };

  static String get(String key, String lang) {
    final map = _strings[lang] ?? _strings['en']!;
    return map[key] ?? _strings['en']![key] ?? key;
  }
}
