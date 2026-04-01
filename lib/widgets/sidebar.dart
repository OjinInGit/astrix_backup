import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.select<AppProvider, String>((p) => p.language);
    final provider = context.read<AppProvider>();
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Logo mark
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.waves, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 20),
            const Divider(indent: 8, endIndent: 8, height: 1),
            const SizedBox(height: 10),
            _NavBtn(
              icon: Icons.settings_remote_rounded,
              label: AppStrings.get('controls', lang),
              onTap: () => provider.setOverlay('controls'),
            ),
            _NavBtn(
              icon: Icons.menu_book_rounded,
              label: AppStrings.get('manual', lang),
              onTap: () => provider.setOverlay('manual'),
            ),
            _NavBtn(
              icon: Icons.tune_rounded,
              label: AppStrings.get('settings', lang),
              onTap: () => provider.setOverlay('settings'),
            ),
            const Spacer(),
            _NavBtn(
              icon: Icons.exit_to_app_rounded,
              label: AppStrings.get('exit', lang),
              color: cs.error,
              onTap: () => _confirmExit(context, lang),
            ),
            const SizedBox(height: 16),
          ],
        ),
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

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _NavBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onPrimaryContainer;
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: c, size: 24),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: c,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
