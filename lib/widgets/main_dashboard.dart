import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/update_log.dart';
import '../models/water_data.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.select<AppProvider, String>((p) => p.language);
    final data = context.select<AppProvider, WaterData?>(
      (p) => p.currentWaterData,
    );
    final logs = context.select<AppProvider, List<UpdateLog>>((p) => p.logs);
    final connected = context.select<AppProvider, bool>(
      (p) => p.deviceConnected,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('app_title', lang),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppStrings.get('app_subtitle', lang),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                _ConnStatus(
                  connected: connected,
                  label: AppStrings.get(
                    connected ? 'connected' : 'disconnected',
                    lang,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Parameters grid ───────────────────────────
            Text(
              AppStrings.get('water_params', lang),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ParamCard(
                    label: AppStrings.get('dissolved_oxygen', lang),
                    value: data != null
                        ? '${data.dissolvedOxygen.toStringAsFixed(2)} mg/L'
                        : '--',
                    icon: Icons.bubble_chart_rounded,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ParamCard(
                    label: AppStrings.get('ph', lang),
                    value: data != null ? data.ph.toStringAsFixed(2) : '--',
                    icon: Icons.science_rounded,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ParamCard(
                    label: AppStrings.get('temperature', lang),
                    value: data != null
                        ? '${data.temperature.toStringAsFixed(1)} °C'
                        : '--',
                    icon: Icons.thermostat_rounded,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ParamCard(
                    label: AppStrings.get('turbidity', lang),
                    value: data != null
                        ? '${data.turbidity.toStringAsFixed(1)} NTU'
                        : '--',
                    icon: Icons.opacity_rounded,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Category bar ──────────────────────────────
            _CategoryBar(
              category: data?.category ?? '--',
              label: AppStrings.get('water_quality', lang),
            ),
            const SizedBox(height: 14),

            // ── Update logs ───────────────────────────────
            Text(
              AppStrings.get('update_logs', lang),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.get('no_logs', lang),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (_, i) => _LogItem(log: logs[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget helpers ────────────────────────────────────────

class _ConnStatus extends StatelessWidget {
  final bool connected;
  final String label;
  const _ConnStatus({required this.connected, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = connected ? Colors.green : Colors.red;
    return Row(
      children: [
        Icon(connected ? Icons.wifi : Icons.wifi_off, color: color, size: 16),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}

class _ParamCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ParamCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.09),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String category;
  final String label;
  const _CategoryBar({required this.category, required this.label});

  Color _color(String c) {
    switch (c.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'average':
        return Colors.orange;
      case 'bad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(category);
    return Card(
      elevation: 0,
      color: color.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          children: [
            Icon(Icons.analytics_rounded, color: color, size: 20),
            const SizedBox(width: 10),
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final UpdateLog log;
  const _LogItem({required this.log});

  IconData _icon(String t) {
    switch (t) {
      case 'config':
        return Icons.check_circle_rounded;
      case 'feeding':
        return Icons.restaurant_rounded;
      case 'error':
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _color(String t) {
    switch (t) {
      case 'config':
        return Colors.green;
      case 'feeding':
        return Colors.teal;
      case 'error':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final color = _color(log.type);

    return Dismissible(
      key: Key(log.id),
      onDismissed: (_) => provider.removeLog(log.id),
      // Swipe left
      background: _DismissBg(align: Alignment.centerLeft),
      // Swipe right
      secondaryBackground: _DismissBg(align: Alignment.centerRight),
      child: Card(
        margin: const EdgeInsets.only(bottom: 5),
        elevation: 0,
        child: ListTile(
          dense: true,
          leading: Icon(_icon(log.type), color: color, size: 20),
          title: Text(log.message, style: const TextStyle(fontSize: 12)),
          subtitle: Text(
            DateFormat('MMM d, hh:mm a').format(log.timestamp),
            style: const TextStyle(fontSize: 10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
        ),
      ),
    );
  }
}

class _DismissBg extends StatelessWidget {
  final Alignment align;
  const _DismissBg({required this.align});

  @override
  Widget build(BuildContext context) => Container(
    alignment: align,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: Colors.red.shade50,
    child: const Icon(Icons.delete_rounded, color: Colors.red),
  );
}
