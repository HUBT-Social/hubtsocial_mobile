import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_bloc.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_event.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_state.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/loading_overlay.dart';
import 'package:hubtsocial_mobile/src/features/main_wrapper/presentation/widgets/main_app_bar.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/screens/academic_result_chart_screen.dart';
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
  late AcademicResultBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<AcademicResultBloc>();
    _bloc.add(const GetAcademicResult());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AcademicResultBloc>(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kết quả học tập'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              context.pop();
            },
          ),
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
              return const LoadingOverlay(loading: true, child: SizedBox());
            } else if (state is AcademicResultLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverallResult(state),
                    const SizedBox(height: 20),
                    _buildScoreTable(state.subjectScores),
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
      ),
    );
  }

  Widget _buildOverallResult(AcademicResultLoaded state) {
    return Card(
      color: context.colorScheme.primary.withOpacity(0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.yellow.shade700),
                const SizedBox(width: 8),
                Text(
                  'Tổng hợp kết quả',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TBC thang điểm 10: ${state.totalAverageScore10.toStringAsFixed(2)}',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        'Số tín chỉ đã tích luỹ: ${state.totalCreditsAchieved}',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.secondary,
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    state.grade,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
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
        Row(
          children: [
            Icon(Icons.bar_chart, color: context.colorScheme.primary),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                AppRoute.classAnalysis.path;
              },
              child: Text(
                'Biểu đồ phân tích',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
            },
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                    color: context.colorScheme.primary.withOpacity(0.1)),
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
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
