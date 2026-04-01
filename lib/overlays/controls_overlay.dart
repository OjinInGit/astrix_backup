import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/feeding_schedule.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({super.key});

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  late List<FeedingSchedule> _local;
  late double _feedAmt;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppProvider>();
    _local = p.schedules
        .map(
          (s) => FeedingSchedule(hour: s.hour, minute: s.minute, isPM: s.isPM),
        )
        .toList();
    _feedAmt = p.feedAmount;
  }

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
        title: Text(
          AppStrings.get('device_config', lang),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Feed amount ────────────────────────────────
          Text(
            AppStrings.get('feed_amount', lang),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount'),
                      Text(
                        '${_feedAmt.toStringAsFixed(2)} kg',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _feedAmt,
                    min: 0.1,
                    max: 5.0,
                    divisions: 49,
                    label: '${_feedAmt.toStringAsFixed(2)} kg',
                    onChanged: (v) => setState(() => _feedAmt = v),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.10 kg', style: TextStyle(fontSize: 10)),
                      Text('5.00 kg', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Feeding schedules ──────────────────────────
          Text(
            AppStrings.get('feeding_schedules', lang),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.get('schedule_note', lang),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),

          ...List.generate(
            6,
            (i) => _ScheduleCard(
              index: i,
              schedule: _local[i],
              onChanged: (s) => setState(() => _local[i] = s),
            ),
          ),

          const SizedBox(height: 20),

          // ── Save ──────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.save_rounded),
              label: Text(AppStrings.get('save_changes', lang)),
              onPressed: () async {
                for (int i = 0; i < 6; i++) {
                  provider.updateSchedule(i, _local[i]);
                }
                provider.setFeedAmount(_feedAmt);
                await provider.saveSchedules();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppStrings.get('saved', lang))),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Schedule Card ─────────────────────────────────────────

class _ScheduleCard extends StatefulWidget {
  final int index;
  final FeedingSchedule schedule;
  final ValueChanged<FeedingSchedule> onChanged;

  const _ScheduleCard({
    required this.index,
    required this.schedule,
    required this.onChanged,
  });

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard> {
  late int _hour;
  late int _minute;
  late bool _isPM;

  @override
  void initState() {
    super.initState();
    _hour = widget.schedule.hour;
    _minute = widget.schedule.minute;
    _isPM = widget.schedule.isPM;
  }

  void _emit() => widget.onChanged(
    FeedingSchedule(hour: _hour, minute: _minute, isPM: _isPM),
  );

  @override
  Widget build(BuildContext context) {
    final h = _hour.toString().padLeft(2, '0');
    final m = _minute.toString().padLeft(2, '0');
    final period = _isPM ? 'PM' : 'AM';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule ${widget.index + 1}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              '$h:$m $period',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Hour — vertical slider 1..12
                  _VSlider(
                    label: 'Hour',
                    value: _hour.toDouble(),
                    min: 1,
                    max: 12,
                    divisions: 11,
                    display: _hour.toString().padLeft(2, '0'),
                    onChanged: (v) => setState(() {
                      _hour = v.round();
                      _emit();
                    }),
                  ),
                  // Minute — vertical slider 0..55 step 5
                  _VSlider(
                    label: 'Min',
                    value: _minute.toDouble(),
                    min: 0,
                    max: 55,
                    divisions: 11,
                    display: _minute.toString().padLeft(2, '0'),
                    onChanged: (v) => setState(() {
                      _minute = ((v / 5).round() * 5).clamp(0, 55);
                      _emit();
                    }),
                  ),
                  // AM / PM toggle presented vertically
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Period', style: TextStyle(fontSize: 11)),
                      const SizedBox(height: 6),
                      RotatedBox(
                        quarterTurns: -1,
                        child: Switch(
                          value: _isPM,
                          onChanged: (v) => setState(() {
                            _isPM = v;
                            _emit();
                          }),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        period,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
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

class _VSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  const _VSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 11)),
        Expanded(
          child: RotatedBox(
            quarterTurns: -1,
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        Text(
          display,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
