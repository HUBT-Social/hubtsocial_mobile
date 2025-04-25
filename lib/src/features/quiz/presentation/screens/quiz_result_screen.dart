import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:lottie/lottie.dart';

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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppLotties.favourite,
                width: 160.r,
                height: 160.r,
                fit: BoxFit.cover,
              ),
              Text(
                context.loc.congratulation,
                style: context.textTheme.headlineLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                context.loc.youHaveCompletedQuiz,
                style: context.textTheme.labelLarge,
              ),
              SizedBox(height: 24.h),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Text(context.loc.score,
                              style: context.textTheme.titleMedium),
                          Text(
                            "$score / $total",
                            style: context.textTheme.headlineLarge,
                          ),
                          SizedBox(height: 6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 28.h,
                                  child: LinearProgressIndicator(
                                    value: score / total,
                                    backgroundColor: context.colorScheme.error,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        context.colorScheme.primary),
                                    minHeight: 28.h,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                Text(
                                  "${((score / total) * 100).round()}%",
                                  style: context.textTheme.titleLarge?.copyWith(
                                      color: context.colorScheme.onPrimary),
                                ),
                              ],
                            ),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80.h),
              ElevatedButton.icon(
                onPressed: () => AppRoute.home.go(context),
                label: Text(context.loc.backToHomepage),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(48.h),
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}
