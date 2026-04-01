import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/main_dashboard.dart';
import '../widgets/sidebar.dart';
import '../overlays/controls_overlay.dart';
import '../overlays/manual_overlay.dart';
import '../overlays/settings_overlay.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overlay = context.select<AppProvider, String>(
      (p) => p.currentOverlay,
    );
    final provider = context.read<AppProvider>();

    return PopScope(
      // Allow system back only when no overlay is open
      canPop: overlay == 'none',
      onPopInvoked: (didPop) {
        if (!didPop) provider.setOverlay('none');
      },
      child: Scaffold(
        body: Stack(
          children: [
            // ── Always-visible base layout ─────────────────
            const Row(
              children: [
                Sidebar(),
                Expanded(child: MainDashboard()),
              ],
            ),
            // ── Sliding overlays ───────────────────────────
            _SlidePanel(
              visible: overlay == 'controls',
              child: const ControlsOverlay(),
            ),
            _SlidePanel(
              visible: overlay == 'manual',
              child: const ManualOverlay(),
            ),
            _SlidePanel(
              visible: overlay == 'settings',
              child: const SettingsOverlay(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slides a full-screen panel in from the right.
class _SlidePanel extends StatelessWidget {
  final bool visible;
  final Widget child;

  const _SlidePanel({required this.visible, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 280),
      offset: visible ? Offset.zero : const Offset(1.0, 0),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: visible ? 1.0 : 0.0,
        child: SizedBox.expand(child: child),
      ),
    );
  }
}
