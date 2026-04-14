// lib/widgets/exercise_card_widget.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/training_data.dart';
import '../services/timer_service.dart';
import '../services/app_theme.dart';

class ExerciseCardWidget extends StatefulWidget {
  final Exercise exercise;
  final String exerciseId;

  const ExerciseCardWidget({
    super.key,
    required this.exercise,
    required this.exerciseId,
  });

  @override
  State<ExerciseCardWidget> createState() => _ExerciseCardWidgetState();
}

class _ExerciseCardWidgetState extends State<ExerciseCardWidget>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  int _selectedVariation = 0;
  late List<List<bool>> _checked; // [variationIndex][serieIndex]
  late AnimationController _expandCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _checked = widget.exercise.variations
        .map((v) => List<bool>.filled(v.sets, false))
        .toList();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  bool get _allDone {
    final v = _checked[_selectedVariation];
    return v.every((c) => c);
  }

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
    _expanded ? _expandCtrl.forward() : _expandCtrl.reverse();
  }

  void _onCheck(int vi, int si, bool value) {
    HapticFeedback.lightImpact();
    setState(() => _checked[vi][si] = value);
    if (value) {
      final rest = widget.exercise.variations[vi].restSeconds;
      context.read<TimerService>().start(rest, widget.exerciseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerService>();
    final isTimerHere = timer.exerciseId == widget.exerciseId && timer.isActive;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _allDone ? 0.3 : 1.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: _allDone ? 0.97 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isTimerHere ? AppColors.accent.withOpacity(0.4) : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              // ── Header ──
              InkWell(
                onTap: _toggleExpand,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Icon badge
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.exercise.icon,
                          style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 13,
                            color: Colors.black,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.exercise.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.textPrim,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.exercise.variations[0].name} • ${widget.exercise.variations[0].sets}×${widget.exercise.variations[0].reps}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Chevron
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 280),
                        turns: _expanded ? 0.5 : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Body ──
              SizeTransition(
                sizeFactor: _expandAnim,
                child: Column(
                  children: [
                    const Divider(height: 1, color: AppColors.border),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Variation tabs
                          Row(
                            children: [
                              _varTab('Principal', 0),
                              const SizedBox(width: 8),
                              _varTab('Variação', 1),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Variation content
                          _buildVariationPanel(_selectedVariation),

                          // Timer (only if active for this exercise)
                          if (isTimerHere) ...[
                            const SizedBox(height: 14),
                            _buildTimer(timer),
                          ] else ...[
                            const SizedBox(height: 14),
                            _buildTimerStub(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _varTab(String label, int vi) {
    final active = _selectedVariation == vi;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedVariation = vi),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? AppColors.accent : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              color: active ? Colors.black : AppColors.textMuted2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVariationPanel(int vi) {
    final v = widget.exercise.variations[vi];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(v.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrim)),
        const SizedBox(height: 3),
        Text('${v.sets} séries • ${v.reps} reps • ${v.restSeconds}s descanso',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted2)),
        const SizedBox(height: 12),
        ...List.generate(v.sets, (si) => _buildSerieRow(vi, si)),
      ],
    );
  }

  Widget _buildSerieRow(int vi, int si) {
    final done = _checked[vi][si];
    return GestureDetector(
      onTap: () => _onCheck(vi, si, !done),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: done ? AppColors.accentDim : AppColors.surface2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: done ? AppColors.accent.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Custom checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: done ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: done ? AppColors.accent : AppColors.border,
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Série ${si + 1} — ${widget.exercise.variations[vi].reps} reps',
                style: const TextStyle(fontSize: 14, color: AppColors.textPrim),
              ),
            ),
            if (done)
              const Text('✓', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer(TimerService timer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Circular clock
          SizedBox(
            width: 70, height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(70, 70),
                  painter: _ClockPainter(
                    progress: timer.progress,
                    isLow: timer.isLow,
                  ),
                ),
                Text(
                  timer.display,
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 14,
                    color: timer.isLow ? AppColors.red : AppColors.textPrim,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timer.display,
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 36,
                    letterSpacing: 3,
                    color: timer.isLow ? AppColors.red : AppColors.accent,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _timerBtn(
                      timer.running ? '⏸' : '▶',
                      onTap: () => timer.toggle(),
                      primary: true,
                    ),
                    const SizedBox(width: 6),
                    _timerBtn('+10s', onTap: () => timer.addTime()),
                    const SizedBox(width: 6),
                    _timerBtn('↺', onTap: () => timer.reset()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerStub() {
    final rest = widget.exercise.variations[_selectedVariation].restSeconds;
    final m = rest ~/ 60;
    final s = rest % 60;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 8),
          Text(
            'Descanso: $m:${s.toString().padLeft(2, '0')} — marque uma série para iniciar',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted2),
          ),
        ],
      ),
    );
  }

  Widget _timerBtn(String label, {required VoidCallback onTap, bool primary = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () { HapticFeedback.selectionClick(); onTap(); },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primary ? AppColors.accent : AppColors.surface2,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: primary ? AppColors.accent : AppColors.border),
          ),
          alignment: Alignment.center,
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
    );
  }
}

// ── Painter do relógio circular ──
class _ClockPainter extends CustomPainter {
  final double progress;
  final bool isLow;

  _ClockPainter({required this.progress, required this.isLow});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy) - 5;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    // Progress arc
    final progPaint = Paint()
      ..color = isLow ? AppColors.red : AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progPaint,
    );
  }

  @override
  bool shouldRepaint(_ClockPainter old) =>
      old.progress != progress || old.isLow != isLow;
}
