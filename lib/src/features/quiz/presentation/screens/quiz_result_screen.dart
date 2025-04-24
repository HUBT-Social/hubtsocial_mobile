import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int time;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.time,
  });

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 80.r, color: Colors.amber),
                SizedBox(height: 24.h),
                Text(
                  context.loc.congratulation,
                  style: context.textTheme.headlineLarge,
                ),
                SizedBox(height: 12.h),
                Text(
                  context.loc.youHaveCompletedQuiz,
                  style: context.textTheme.bodyLarge,
                ),
                SizedBox(height: 24.h),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      children: [
                        Text(context.loc.score,
                            style: context.textTheme.titleMedium),
                        Text(
                          "$score / $total",
                          style: context.textTheme.headlineLarge,
                        ),
                        SizedBox(height: 12.h),
                        Text(context.loc.testTime,
                            style: context.textTheme.titleMedium),
                        Text(
                          _formatTime(time),
                          style: context.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                ElevatedButton.icon(
                  onPressed: () => AppRoute.home.go(context),
                  icon: const Icon(Icons.home),
                  label: Text(context.loc.backToHomepage),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(48.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
