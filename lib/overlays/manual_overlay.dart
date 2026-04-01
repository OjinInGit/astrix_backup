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
          _Section(
            title: AppStrings.get('setup', lang),
            icon: Icons.build_rounded,
            color: Colors.blue,
            steps: const [
              'Assemble the solar panel roof upon the feed container, making sure the roof faces East/West. Place slightly away from where you will install the mechanism.',
              'Attach the tube below the container, then connect it to the mechanism\'s intake.',
              'Install the sensor attachment on the mechanism, then place it on the pond edge while the sensor attachment is submerged in water on or slightly below the white line.',
              'Flip the switch to turn the device on.',
              'Install the Astrix DVC App on your mobile device, and connect using the device-specific QR code on the provided pamphlet. Your device shall be ready to go.',
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: AppStrings.get('troubleshooting', lang),
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            custom: const _TroubleshootBody(),
          ),
          const SizedBox(height: 14),
          _Section(
            title: AppStrings.get('maintenance', lang),
            icon: Icons.handyman_rounded,
            color: Colors.green,
            steps: const [
              'Clean the feed reservoir at least once a month to ensure smooth flow of feed and to keep stored feed fresh.',
              'Clean sensors at least twice every three months to ensure accurate readings.',
              'App/Device updates are issued monthly. Keep in touch for further optimizations.',
            ],
          ),
          const SizedBox(height: 20),
          _DevCard(lang: lang),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

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

class _TroubleshootBody extends StatelessWidget {
  const _TroubleshootBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Issue(
          problem: 'Application/device does not connect:',
          fixes: const [
            'Relaunch the app.',
            'Reset the device by pushing the Reset button.',
          ],
        ),
        const SizedBox(height: 10),
        _Issue(
          problem: 'Sensor reads incorrectly or inaccurately:',
          fixes: const [
            'Adjust the sensor\'s position.',
            'Ensure it is unobstructed — no debris covers the sensor while underwater.',
            'Turn off the device, detach and reattach the sensor, then turn it back on.',
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
                Text(
                  AppStrings.get('reach_devs', lang),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Row(Icons.phone_rounded, '09123456789'),
            _Row(Icons.email_rounded, 'astrix@mgmt.org'),
            _Row(Icons.business_rounded, 'Astrix Systems'),
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
