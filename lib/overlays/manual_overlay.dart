import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

class ManualOverlay extends StatelessWidget {
  const ManualOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.select<AppProvider, String>((p) => p.language);
    final provider = context.read<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => provider.setOverlay('none'),
        ),
        title: Text(AppStrings.get('user_manual', lang)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Setup ─────────────────────────────────────
          _Section(
            title: AppStrings.get('setup', lang),
            icon: Icons.build_rounded,
            color: Colors.blue,
            steps: [
              AppStrings.get('setup_step_1', lang),
              AppStrings.get('setup_step_2', lang),
              AppStrings.get('setup_step_3', lang),
              AppStrings.get('setup_step_4', lang),
              AppStrings.get('setup_step_5', lang),
            ],
          ),
          const SizedBox(height: 14),

          // ── Troubleshooting ───────────────────────────
          _Section(
            title: AppStrings.get('troubleshooting', lang),
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            custom: _TroubleshootBody(lang: lang),
          ),
          const SizedBox(height: 14),

          // ── Maintenance ───────────────────────────────
          _Section(
            title: AppStrings.get('maintenance', lang),
            icon: Icons.handyman_rounded,
            color: Colors.green,
            steps: [
              AppStrings.get('maint_step_1', lang),
              AppStrings.get('maint_step_2', lang),
              AppStrings.get('maint_step_3', lang),
            ],
          ),
          const SizedBox(height: 20),

          // ── Developer card ────────────────────────────
          _DevCard(lang: lang),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Reusable section card ──────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String>? steps;
  final Widget? custom;

  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    this.steps,
    this.custom,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (steps != null)
              ...steps!.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: color.withOpacity(0.15),
                        child: Text(
                          '${e.key + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.value,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (custom != null) custom!,
          ],
        ),
      ),
    );
  }
}

// ── Troubleshooting body ───────────────────────────────────

class _TroubleshootBody extends StatelessWidget {
  final String lang;
  const _TroubleshootBody({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Issue(
          problem: AppStrings.get('trouble_issue_1', lang),
          fixes: [
            AppStrings.get('trouble_1_fix_1', lang),
            AppStrings.get('trouble_1_fix_2', lang),
          ],
        ),
        const SizedBox(height: 10),
        _Issue(
          problem: AppStrings.get('trouble_issue_2', lang),
          fixes: [
            AppStrings.get('trouble_2_fix_1', lang),
            AppStrings.get('trouble_2_fix_2', lang),
            AppStrings.get('trouble_2_fix_3', lang),
          ],
        ),
      ],
    );
  }
}

class _Issue extends StatelessWidget {
  final String problem;
  final List<String> fixes;
  const _Issue({required this.problem, required this.fixes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          problem,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 4),
        ...fixes.map(
          (f) => Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Developer contact card ─────────────────────────────────

class _DevCard extends StatelessWidget {
  final String lang;
  const _DevCard({required this.lang});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.groups_rounded, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.get('reach_devs', lang),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Row(Icons.phone_rounded, AppStrings.get('dev_phone', lang)),
            _Row(Icons.email_rounded, AppStrings.get('dev_email', lang)),
            _Row(Icons.business_rounded, AppStrings.get('dev_org', lang)),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Icon(icon, size: 15, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}
