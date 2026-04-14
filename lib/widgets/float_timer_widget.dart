// lib/widgets/float_timer_widget.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/timer_service.dart';
import '../services/app_theme.dart';

class FloatTimerWidget extends StatefulWidget {
  const FloatTimerWidget({super.key});

  @override
  State<FloatTimerWidget> createState() => _FloatTimerWidgetState();
}

class _FloatTimerWidgetState extends State<FloatTimerWidget>
    with SingleTickerProviderStateMixin {
  bool _minimized = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.0, end: 1.0).animate(_pulseCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerService>();
    if (!timer.isActive) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) {
        final glowColor = timer.isLow
            ? AppColors.red.withOpacity(0.3 * _pulseAnim.value)
            : AppColors.accent.withOpacity(0.15);

        return Positioned(
          bottom: 20 + MediaQuery.of(context).padding.bottom,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(minWidth: 170),
              decoration: BoxDecoration(
                color: const Color(0xFF17171F),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: timer.isLow ? AppColors.red : AppColors.accent,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '⏱ DESCANSO',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted2,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _minimized = !_minimized),
                        child: Icon(
                          _minimized
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.textMuted2,
                          size: 18,
                        ),
                      ),
                    ],
                  ),

                  if (!_minimized) ...[
                    const SizedBox(height: 8),
                    // Big time display
                    Center(
                      child: Text(
                        timer.display,
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 44,
                          letterSpacing: 4,
                          color: timer.isDone
                              ? AppColors.accent
                              : timer.isLow
                                  ? AppColors.red
                                  : AppColors.accent,
                          height: 1,
                        ),
                      ),
                    ),
                    // Progress bar
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: timer.progress,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(
                          timer.isLow ? AppColors.red : AppColors.accent,
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Buttons
                    Row(
                      children: [
                        _btn(
                          timer.running ? '⏸' : '▶',
                          onTap: () => timer.toggle(),
                          primary: true,
                        ),
                        const SizedBox(width: 6),
                        _btn('+10s', onTap: () => timer.addTime()),
                        const SizedBox(width: 6),
                        _btn('↺', onTap: () => timer.reset()),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        timer.display,
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 28,
                          letterSpacing: 3,
                          color: timer.isLow ? AppColors.red : AppColors.accent,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _btn(String label, {required VoidCallback onTap, bool primary = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primary ? AppColors.accent : AppColors.surface2,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: primary ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: primary ? Colors.black : AppColors.textPrim,
                fontWeight: primary ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
