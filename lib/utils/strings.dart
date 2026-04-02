// ============================================================
// LOCALIZATION — Astrix DVC
// ============================================================
// HOW TO ADD YOUR LOCAL LANGUAGE:
//
//  1. Add a new map entry below the 'en' block using your
//     language code as the key (e.g. 'ceb' for Cebuano,
//     'fil' for Filipino).
//
//  2. Copy EVERY key from the 'en' block into your new entry
//     and provide the translated value for each key.
//     Missing keys automatically fall back to English.
//
//  3. In lib/overlays/settings_overlay.dart, find the comment
//     marked "ADD LANGUAGE OPTION HERE" and add a
//     DropdownMenuItem with your language code and display name.
//
//  4. AppProvider.setLanguage('your_code') is already wired —
//     no other changes are needed anywhere else.
// ============================================================

class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    'en': {
      // ── General UI ──────────────────────────────────────
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
      'back': 'Back',
      'save_changes': 'Save Changes',
      'saved': 'Configuration saved!',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'no_logs': 'No logs yet.',
      'yes': 'Yes',
      'no': 'No',
      'exit_confirm': 'Do you really want to exit the application?',
      'version': 'Version 1.4.4',

      // ── Units ────────────────────────────────────────────
      'unit_do': 'mg/L',
      'unit_temp': '°C',
      'unit_turbidity': 'NTU',

      // ── Water quality categories ─────────────────────────
      'cat_good': 'Good',
      'cat_average': 'Average',
      'cat_bad': 'Bad',
      'cat_unknown': 'Unknown',

      // ── Controls overlay ─────────────────────────────────
      'device_config': 'Device Configuration and Controls',
      'feed_amount': 'Feed Amount (kg)',
      'amount_label': 'Amount',
      'feed_min': '0.10 kg',
      'feed_max': '5.00 kg',
      'feeding_schedules': 'Feeding Schedules',
      'schedule_note': 'Good water: all 6  •  Average: 3  •  Bad: 1–2',
      'schedule_prefix': 'Schedule',
      'slider_hour': 'Hour',
      'slider_min': 'Min',
      'slider_period': 'Period',

      // ── Manual overlay — headings ─────────────────────────
      'user_manual': 'User Manual',
      'setup': 'Setup',
      'troubleshooting': 'Troubleshooting',
      'maintenance': 'Maintenance',
      'reach_devs': 'Reach out to the devs!',

      // ── Setup steps ──────────────────────────────────────
      'setup_step_1':
          'Assemble the solar panel roof upon the feed container, making sure '
          'the roof faces East/West. Place slightly away from where you will '
          'install the mechanism.',
      'setup_step_2':
          'Attach the tube below the container, then connect it to the '
          'mechanism\'s intake.',
      'setup_step_3':
          'Install the sensor attachment on the mechanism, then place it on '
          'the pond edge while the sensor attachment is submerged in water '
          'or slightly below the white line.',
      'setup_step_4': 'Flip the switch to turn the device on.',
      'setup_step_5':
          'Connect to the device\'s Wi-Fi network using the Astrix DVC App. '
          'Your device shall be ready to go.',

      // ── Troubleshooting — issue headings ─────────────────
      'trouble_issue_1': 'Application/device does not connect:',
      'trouble_issue_2': 'Sensor reads incorrectly or inaccurately:',

      // ── Troubleshooting — fixes for issue 1 ──────────────
      'trouble_1_fix_1': 'Relaunch the app.',
      'trouble_1_fix_2': 'Reset the device by pushing the Reset button.',

      // ── Troubleshooting — fixes for issue 2 ──────────────
      'trouble_2_fix_1': 'Adjust the sensor\'s position.',
      'trouble_2_fix_2':
          'Ensure it is unobstructed — no debris covers the sensor '
          'while underwater.',
      'trouble_2_fix_3':
          'Turn off the device, detach and reattach the sensor, '
          'then turn it back on.',

      // ── Maintenance steps ─────────────────────────────────
      'maint_step_1':
          'Clean the feed reservoir at least once a month to ensure smooth '
          'flow of feed and to keep stored feed fresh.',
      'maint_step_2':
          'Clean sensors at least twice every three months to ensure '
          'accurate readings.',
      'maint_step_3':
          'App/Device updates are issued monthly. Keep in touch for '
          'further optimizations.',

      // ── Developer contact details ─────────────────────────
      'dev_phone': '09123456789',
      'dev_email': 'astrix@mgmt.org',
      'dev_org': 'Astrix Systems',

      // ── Settings overlay ──────────────────────────────────
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'language': 'Language',

      // ── ADD MORE KEYS HERE as the app grows ───────────────
      'feed_helper': 'Enter any amount greater than 0 kg.',
      'feed_invalid': 'Please enter a valid amount greater than 0.',
    },
    'war': {
      // ── General UI ──────────────────────────────────────
      'app_title': 'Astrix DVC',
      'app_subtitle': 'ng Astrix Systems',
      'water_params': 'Water Parameters',
      'dissolved_oxygen': 'DO',
      'ph': 'pH',
      'temperature': 'Temperature han Tubig',
      'turbidity': 'Turbidity',
      'water_quality': 'Kalidad han Tubig',
      'update_logs': 'Mga Updates',
      'controls': 'Mga Kontrol',
      'manual': 'Manual',
      'settings': 'Settings',
      'exit': 'Gawas',
      'back': 'Balik',
      'save_changes': 'I-Save',
      'saved': 'Na-Save na!',
      'connected': 'Konektado',
      'disconnected': 'Di Konektado',
      'no_logs': 'Waray pa updates.',
      'yes': 'Oo',
      'no': 'Diri',
      'exit_confirm': 'I-Exit an application?',
      'version': 'Bersyon 1.4.4',

      // ── Units ────────────────────────────────────────────
      'unit_do': 'mg/L',
      'unit_temp': '°C',
      'unit_turbidity': 'NTU',

      // ── Water quality categories ─────────────────────────
      'cat_good': 'Maupay',
      'cat_average': 'Aberids',
      'cat_bad': 'Maraot',
      'cat_unknown': 'Ambot',

      // ── Controls overlay ─────────────────────────────────
      'device_config': 'Pag-taod han Device',
      'feed_amount': 'Kadamo han Tubong (kg)',
      'amount_label': 'Kadamo',
      'feed_min': '0.10 kg',
      'feed_max': '5.00 kg',
      'feeding_schedules': 'Mga Iskedyul',
      'schedule_note': 'Maupay: all 6  •  Aberids: 3  •  Maraot: 1–2',
      'schedule_prefix': 'Iskedyul',
      'slider_hour': 'Oras',
      'slider_min': 'Minutos',
      'slider_period': 'Peryod',

      // ── Manual overlay — headings ─────────────────────────
      'user_manual': 'User Manual',
      'setup': 'Setup',
      'troubleshooting': 'Pag-ayad',
      'maintenance': 'Pag-atiman',
      'reach_devs': 'Pakigstorya han mga devs!',

      // ── Setup steps ──────────────────────────────────────
      'setup_step_1':
          'Itaod an solar panel didat igbaw hit burutangan hit tubong, '
          'siguradua na umatubang pa-East/West. Idistansya ha lugar kun '
          'diin mo iinstall an mekanismo.',
      'setup_step_2':
          'Itaod an tubo ha burutangan, ngan han intake hit mekanismo.',
      'setup_step_3':
          'Iinstall an sensor attachment ha mekanismo, ibutang ha ligid '
          'hit isdaan, ngan ilublob an sensor ha tubig ubos han puti na'
          'linya.',
      'setup_step_4': 'I-on an switch ha device.',
      'setup_step_5':
          'Ikonek an device han Wi-Fi han device ha imo selpon gamit '
          'an ASTRIX DVC App. ',

      // ── Troubleshooting — issue headings ─────────────────
      'trouble_issue_1': 'Diri nakonek:',
      'trouble_issue_2': 'Maraot an basa hit sensor:',

      // ── Troubleshooting — fixes for issue 1 ──────────────
      'trouble_1_fix_1': 'I-relaunch an app.',
      'trouble_1_fix_2': 'Pinduta an Reset button ha device.',

      // ── Troubleshooting — fixes for issue 2 ──────────────
      'trouble_2_fix_1': 'I-adjas an pwesto han sensor.',
      'trouble_2_fix_2':
          'Sigurua na waray may nakaulang ha sensor '
          'ha ilarom hit tubig.',
      'trouble_2_fix_3':
          'parunga an device, tanggala ngan itaod balik an sensor, '
          'ngan balika pagpaandar',

      // ── Maintenance steps ─────────────────────────────────
      'maint_step_1':
          'Limpyuhi atlis kausa kada bulan it burutangan hit tubong ',
      'maint_step_2':
          'Limpyuhi it sensor atlis kaduha o katulo kada bulan para '
          'masigurado na sakto it iya basa.',
      'maint_step_3':
          'Kada bulan kami magpagawas hin update hit app. Sanglit,  '
          'burubantayi panalagsa kun may ada.',

      // ── Developer contact details ─────────────────────────
      'dev_phone': '09123456789',
      'dev_email': 'astrix@mgmt.org',
      'dev_org': 'Astrix Systems',

      // ── Settings overlay ──────────────────────────────────
      'dark_mode': 'Pagpasirom',
      'notifications': 'Mga Pasabot',
      'language': 'Lengwahe',

      // ── ADD MORE KEYS HERE as the app grows ───────────────
      'feed_helper': 'Pagbutang hin bis ano na amount na mas dako ha 0 kg.',
      'feed_invalid': 'Pagbutang hin sakto na amount na mas dako ha 0.',
    },
  };

  static String get(String key, String lang) {
    final map = _strings[lang] ?? _strings['en']!;
    return map[key] ?? _strings['en']![key] ?? key;
  }
}
