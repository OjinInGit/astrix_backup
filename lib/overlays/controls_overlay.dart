import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late TextEditingController _feedController;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppProvider>();
    _local = p.schedules
        .map(
          (s) => FeedingSchedule(hour: s.hour, minute: s.minute, isPM: s.isPM),
        )
        .toList();
    // Initialise the text field with the saved feed amount.
    _feedController = TextEditingController(
      text: p.feedAmount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _feedController.dispose();
    super.dispose();
  }

  // Parses the text field and returns a valid positive double, or null.
  double? get _parsedFeedAmount {
    final v = double.tryParse(_feedController.text.trim());
    if (v == null || v <= 0) return null;
    return v;
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
          // ── Feed amount input ────────────────────────
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
              child: TextField(
                controller: _feedController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // Only allow digits and a single decimal point.
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  suffixText: 'kg',
                  hintText: '0.00',
                  helperText: AppStrings.get('feed_helper', lang),
                  border: const OutlineInputBorder(),
                  errorText:
                      _feedController.text.isNotEmpty &&
                          _parsedFeedAmount == null
                      ? AppStrings.get('feed_invalid', lang)
                      : null,
                ),
                onChanged: (_) =>
                    setState(() {}), // refresh errorText on each keystroke
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
              onPressed: _parsedFeedAmount == null
                  ? null // disabled while input is invalid
                  : () async {
                      for (int i = 0; i < 6; i++) {
                        provider.updateSchedule(i, _local[i]);
                      }
                      provider.setFeedAmount(_parsedFeedAmount!);
                      await provider.saveSchedules();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppStrings.get('saved', lang)),
                          ),
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
// Schedule card — drum-roll time picker
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

  static const double _itemH = 44.0;
  static const int _extraItems = 2;
  static const double _wheelH = _itemH * (1 + _extraItems * 2);

  @override
  void initState() {
    super.initState();
    _hour = widget.schedule.hour;
    _minute = widget.schedule.minute;
    _isPM = widget.schedule.isPM;

    _hourCtrl = FixedExtentScrollController(initialItem: _hours.indexOf(_hour));
    _minCtrl = FixedExtentScrollController(
      initialItem: _minutes
          .indexWhere((m) => m == _minute)
          .clamp(0, _minutes.length - 1),
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

  // ── Single drum column — label lives INSIDE this widget ──
  // This is the key fix: the label and its drum are one Column,
  // so they can never become misaligned regardless of what sits
  // beside them in the parent Row.
  Widget _drum<T>({
    required String columnLabel,
    required FixedExtentScrollController controller,
    required List<T> items,
    required String Function(T) display,
    required void Function(int) onSelected,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label sits directly above its wheel — always aligned.
        Text(
          columnLabel,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withOpacity(0.55),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 72,
          height: _wheelH,
          child: Stack(
            children: [
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
                    final sel =
                        controller.hasClients && controller.selectedItem == i;
                    return Center(
                      child: Text(
                        display(items[i]),
                        style: TextStyle(
                          fontSize: sel ? 22 : 17,
                          fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                          color: sel
                              ? cs.primary
                              : cs.onSurface.withOpacity(0.35),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Selection highlight band
              Positioned(
                top: _itemH * _extraItems,
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final h = _hour.toString().padLeft(2, '0');
    final m = _minute.toString().padLeft(2, '0');
    final per = _isPM ? 'PM' : 'AM';
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: schedule label + live read-out
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
                Text(
                  '$h:$m $per',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Three drums in one Row. The ':' separator is vertically
            // centred relative to the wheels, not the labels, using
            // crossAxisAlignment.end so it sits at the wheel level.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Hour
                _drum<int>(
                  columnLabel: AppStrings.get('slider_hour', lang),
                  controller: _hourCtrl,
                  items: _hours,
                  display: (h) => h.toString().padLeft(2, '0'),
                  onSelected: (i) => setState(() {
                    _hour = _hours[i];
                    _emit();
                  }),
                ),

                // Colon separator — padded from the bottom to sit
                // at mid-wheel height, clear of the labels above.
                Padding(
                  padding: const EdgeInsets.only(bottom: _wheelH / 2 - 12),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),

                // Minute
                _drum<int>(
                  columnLabel: AppStrings.get('slider_min', lang),
                  controller: _minCtrl,
                  items: _minutes,
                  display: (m) => m.toString().padLeft(2, '0'),
                  onSelected: (i) => setState(() {
                    _minute = _minutes[i];
                    _emit();
                  }),
                ),

                // Period
                _drum<String>(
                  columnLabel: AppStrings.get('slider_period', lang),
                  controller: _periodCtrl,
                  items: _periods,
                  display: (p) => p,
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
