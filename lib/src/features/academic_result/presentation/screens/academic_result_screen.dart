import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result/academic_result_bloc.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result/academic_result_event.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result/academic_result_state.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';

// Import for CustomAppBar and LoadingOverlay will be added after finding their definitions
// import 'package:hubtsocial_mobile/src/core/common/widgets/app_bar.dart';
// import 'package:hubtsocial_mobile/src/core/common/widgets/loading_overlay.dart';

class AcademicResultScreen extends StatefulWidget {
  const AcademicResultScreen({super.key});

  @override
  State<AcademicResultScreen> createState() => _AcademicResultScreenState();
}

class _AcademicResultScreenState extends State<AcademicResultScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AcademicResultBloc>().add(const GetAcademicResultEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          context.loc.academic_result,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [],
      ),
      body: BlocConsumer<AcademicResultBloc, AcademicResultState>(
        listener: (context, state) {
          if (state is AcademicResultError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AcademicResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AcademicResultLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _buildOverallResult(state),
                  SizedBox(height: 20.h),
                  _buildScoreTable(state.subjectScores),
                  SizedBox(height: 100.h),
                ],
              ),
            );
          } else if (state is AcademicResultError) {
            return Center(child: Text('Error: ${state.failure.message}'));
          } else {
            return const Center(child: Text('Please fetch data'));
          }
        },
      ),
    );
  }

  Widget _buildOverallResult(AcademicResultLoaded state) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: context.colorScheme.primary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events,
                    color: context.colorScheme.onPrimary, size: 36.r),
                SizedBox(width: 8.w),
                Text(
                  'Tổng hợp kết quả',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        'TBC thang điểm 10: ${state.totalAverageScore10.toStringAsFixed(2)}',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Số tín chỉ đã tích luỹ: ${state.totalCreditsAchieved}',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 68.r,
                  height: 68.r,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.outline,
                        blurRadius: 2.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    state.grade,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Môn chờ điểm',
                  state.pendingSubjects,
                  context,
                ),
                _buildStatItem(
                  'Môn thi lại',
                  state.retakeSubjects,
                  context,
                ),
                _buildStatItem(
                  'Môn học lại',
                  state.failedSubjects,
                  context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreTable(List<SubjectScoreModel> subjectScores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            AppRoute.classAnalysis.push(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            width: double.infinity,
            color: context.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Icon(Icons.stacked_bar_chart_rounded,
                    color: context.colorScheme.onPrimaryContainer, size: 24.r),
                SizedBox(width: 8.w),
                Text(
                  'Biểu đồ phân tích',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
        // SizedBox(height: 12.w),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2.25),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(1.25),
            3: FlexColumnWidth(1.5),
          },
          border: TableBorder.symmetric(
            inside:
                BorderSide(color: context.colorScheme.surfaceContainerHighest),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: context.colorScheme.primary),
              children: [
                _buildTableHeader('Mã học phần', context),
                _buildTableHeader('Tên học phần', context),
                _buildTableHeader('Số tín chỉ', context),
                _buildTableHeader('Thang điểm 10', context),
              ],
            ),
            ...subjectScores.map((subject) => TableRow(
                  children: [
                    _buildTableCell(subject.subject, context),
                    _buildTableCell(subject.subject,
                        context), // Assuming subject name is the same as code for now
                    _buildTableCell(subject.score4.toStringAsFixed(0),
                        context), // Assuming score4 is credits
                    _buildTableCell(
                        subject.score10.toStringAsFixed(1), context),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: Text(
        text,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.onPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: Text(
        text,
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
