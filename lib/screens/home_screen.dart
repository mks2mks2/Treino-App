// lib/screens/home_screen.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/training_data.dart';
import '../services/app_theme.dart';
import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _quote = '';
  Timer? _quoteTimer;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _nextQuote();
    _fadeCtrl.forward();
    _quoteTimer = Timer.periodic(const Duration(seconds: 9), (_) => _nextQuote());
  }

  void _nextQuote() {
    _fadeCtrl.reverse().then((_) {
      setState(() {
        _quote = kQuotes[Random().nextInt(kQuotes.length)];
      });
      _fadeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _DayCard(day: kTrainingDays[i]),
                  childCount: kTrainingDays.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, AppColors.accent2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              'MINHA\nROTINA',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 52,
                letterSpacing: 6,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              _quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted2,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ESCOLHA O DIA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
                color: AppColors.textMuted2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Day Card ────────────────────────────────────────────
class _DayCard extends StatefulWidget {
  final TrainingDay day;
  const _DayCard({required this.day});

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    _scaleCtrl.forward().then((_) => _scaleCtrl.reverse().then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => WorkoutScreen(day: widget.day)),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top accent line
              Container(
                height: 2,
                width: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.accent2],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Spacer(),
              Text(
                widget.day.key,
                style: GoogleFonts.bebasNeue(
                  fontSize: 32,
                  letterSpacing: 3,
                  color: AppColors.accent,
                  height: 1,
                ),
              ),
              Text(
                widget.day.label,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted2),
              ),
              const SizedBox(height: 8),
              Text(
                widget.day.focus,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrim,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    widget.day.time,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
