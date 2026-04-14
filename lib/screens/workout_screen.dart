// lib/screens/workout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/training_data.dart';
import '../services/app_theme.dart';
import '../services/timer_service.dart';
import '../widgets/exercise_card_widget.dart';
import '../widgets/float_timer_widget.dart';

class WorkoutScreen extends StatelessWidget {
  final TrainingDay day;
  const WorkoutScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  backgroundColor: AppColors.bg,
                  surfaceTintColor: Colors.transparent,
                  leading: IconButton(
                    icon: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back, size: 18, color: AppColors.textPrim),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.key} — ${day.focus}',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 22,
                          letterSpacing: 2,
                          color: AppColors.accent,
                        ),
                      ),
                      Text(
                        '⏱ ${day.time}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted2),
                      ),
                    ],
                  ),
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(height: 1, color: AppColors.border),
                  ),
                ),

                // Exercise groups
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, gi) => _buildGroup(ctx, day.groups[gi]),
                      childCount: day.groups.length,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating timer overlay
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Stack(
                children: const [FloatTimerWidget()],
              ),
            ),
          ),

          // Done button fixed at bottom
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16, 12, 16, 16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bg.withOpacity(0),
                    AppColors.bg,
                  ],
                ),
              ),
              child: _DoneButton(dayKey: day.key),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroup(BuildContext context, MuscleGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group title
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                width: 3, height: 16,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                group.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: AppColors.textMuted2,
                ),
              ),
            ],
          ),
        ),
        // Exercises
        ...group.exercises.asMap().entries.map((e) {
          final exId = '${group.name}_${e.key}';
          return ExerciseCardWidget(
            exercise: e.value,
            exerciseId: exId,
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Done Button ─────────────────────────────────────────
class _DoneButton extends StatelessWidget {
  final String dayKey;
  const _DoneButton({required this.dayKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        _showCelebration(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, Color(0xFFB0D400)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          '🏁  TREINO CONCLUÍDO',
          textAlign: TextAlign.center,
          style: GoogleFonts.bebasNeue(
            fontSize: 22,
            letterSpacing: 4,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showCelebration(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (ctx, anim, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, _, __) => _CelebrationDialog(
        onClose: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
          context.read<TimerService>().dismiss();
        },
      ),
    );
  }
}

class _CelebrationDialog extends StatelessWidget {
  final VoidCallback onClose;
  const _CelebrationDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: const Color(0xFF17171F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.accent),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.15),
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 14),
            Text(
              'TREINO\nCONCLUÍDO!',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 36,
                letterSpacing: 4,
                color: AppColors.accent,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você arrasou hoje.\nDescanse bem!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted2, fontSize: 14),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'FECHAR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    letterSpacing: 4,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
