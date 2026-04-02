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
          // ── Feed amount ──────────────────────────────
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
                      Text(AppStrings.get('amount_label', lang)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.get('feed_min', lang),
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        AppStrings.get('feed_max', lang),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Feeding schedules ────────────────────────
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
              lang: lang,
              onChanged: (s) => setState(() => _local[i] = s),
            ),
          ),

          const SizedBox(height: 20),

          // ── Save ─────────────────────────────────────
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

// ════════════════════════════════════════════════════════════
// Schedule Card — drum-roll time picker
// ════════════════════════════════════════════════════════════

class _ScheduleCard extends StatefulWidget {
  final int index;
  final FeedingSchedule schedule;
  final String lang;
  final ValueChanged<FeedingSchedule> onChanged;

  const _ScheduleCard({
    required this.index,
    required this.schedule,
    required this.lang,
    required this.onChanged,
  });

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard> {
  // Hours 1–12, minutes 00/05/.../55, period 0=AM 1=PM
  static const List<int> _hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  static const List<int> _minutes = [
    0,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
  ];
  static const List<String> _periods = ['AM', 'PM'];

  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minCtrl;
  late FixedExtentScrollController _periodCtrl;

  late int _hour;
  late int _minute;
  late bool _isPM;

  // Item height for every drum-roll wheel
  static const double _itemH = 44.0;
  // How many items are visible above and below the selected item
  static const int _visibleExtra = 2;
  // Total wheel height = selected item + items above + items below
  static const double _wheelH = _itemH * (1 + _visibleExtra * 2);

  @override
  void initState() {
    super.initState();
    _hour = widget.schedule.hour;
    _minute = widget.schedule.minute;
    _isPM = widget.schedule.isPM;

    _hourCtrl = FixedExtentScrollController(initialItem: _hours.indexOf(_hour));
    _minCtrl = FixedExtentScrollController(
      initialItem: _minutes.indexOf(
        _minutes.firstWhere((m) => m == _minute, orElse: () => _minutes[0]),
      ),
    );
    _periodCtrl = FixedExtentScrollController(initialItem: _isPM ? 1 : 0);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minCtrl.dispose();
    _periodCtrl.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(
    FeedingSchedule(hour: _hour, minute: _minute, isPM: _isPM),
  );

  // ── Single drum-roll column ─────────────────────────────
  Widget _drum<T>({
    required FixedExtentScrollController controller,
    required List<T> items,
    required String Function(T) label,
    required void Function(int) onSelected,
  }) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 72,
      height: _wheelH,
      child: Stack(
        children: [
          // The scroll wheel
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: _itemH,
            diameterRatio: 1.4,
            perspective: 0.003,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelected,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, i) {
                final selected =
                    controller.hasClients && controller.selectedItem == i;
                return Center(
                  child: Text(
                    label(items[i]),
                    style: TextStyle(
                      fontSize: selected ? 22 : 17,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selected
                          ? cs.primary
                          : cs.onSurface.withOpacity(0.35),
                    ),
                  ),
                );
              },
            ),
          ),

          // Highlight band over the centre item
          Positioned(
            top: _itemH * _visibleExtra,
            left: 0,
            right: 0,
            height: _itemH,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: cs.primary.withOpacity(0.45),
                      width: 1.5,
                    ),
                  ),
                  color: cs.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final h = _hour.toString().padLeft(2, '0');
    final m = _minute.toString().padLeft(2, '0');
    final per = _isPM ? 'PM' : 'AM';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppStrings.get('schedule_prefix', lang)} '
                  '${widget.index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                // Live read-out, mirrors the drum selection
                Text(
                  '$h:$m $per',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Column headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ColLabel(AppStrings.get('slider_hour', lang)),
                _ColLabel(AppStrings.get('slider_min', lang)),
                _ColLabel(AppStrings.get('slider_period', lang)),
              ],
            ),

            const SizedBox(height: 4),

            // Three drum-roll wheels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hour wheel
                _drum<int>(
                  controller: _hourCtrl,
                  items: _hours,
                  label: (h) => h.toString().padLeft(2, '0'),
                  onSelected: (i) => setState(() {
                    _hour = _hours[i];
                    _emit();
                  }),
                ),

                // Separator
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),

                // Minute wheel
                _drum<int>(
                  controller: _minCtrl,
                  items: _minutes,
                  label: (m) => m.toString().padLeft(2, '0'),
                  onSelected: (i) => setState(() {
                    _minute = _minutes[i];
                    _emit();
                  }),
                ),

                // Period wheel
                _drum<String>(
                  controller: _periodCtrl,
                  items: _periods,
                  label: (p) => p,
                  onSelected: (i) => setState(() {
                    _isPM = i == 1;
                    _emit();
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Thin column header label
class _ColLabel extends StatelessWidget {
  final String text;
  const _ColLabel(this.text);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 72,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
        letterSpacing: 0.5,
      ),
    ),
  );
}
