import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/score_distribution_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_chart/academic_result_chart_bloc.dart';

import 'package:hubtsocial_mobile/src/core/injections/injections.dart';

class AcademicResultChartScreen extends StatelessWidget {
  const AcademicResultChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AcademicResultChartBloc>()..add(GetAcademicResultChartEvent()),
      child: const _AcademicResultChartView(),
    );
  }
}

class _AcademicResultChartView extends StatelessWidget {
  const _AcademicResultChartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biểu đồ phân tích'),
      ),
      body: BlocBuilder<AcademicResultChartBloc, AcademicResultChartState>(
        builder: (context, state) {
          return Container();

          // return LoadingOverlay(
          //   loading: state.maybeMap(loading: (_) => true, orElse: () => false),
          //   child: state.when(
          //     initial: () => const SizedBox(),
          //     loading: () => const SizedBox(),
          //     loaded: (data) => _buildChart(context, data),
          //     error: (message) => Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             message,
          //             style: context.textTheme.bodyLarge?.copyWith(
          //               color: context.colorScheme.error,
          //             ),
          //           ),
          //           const SizedBox(height: 16),
          //           ElevatedButton(
          //             onPressed: () {
          //               context
          //                   .read<AcademicResultChartBloc>()
          //                   .add(const AcademicResultChartEvent.load());
          //             },
          //             child: const Text('Thử lại'),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  Widget _buildChart(BuildContext context, ScoreDistributionModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPieChart(context, data),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, ScoreDistributionModel data) {
    final totalSubjects = data.excellent +
        data.good +
        data.fair +
        data.average +
        data.belowAverage +
        data.fail;

    List<PieChartSectionData> showingSections = [
      PieChartSectionData(
        color: Colors.green, // Xuất sắc
        value: data.excellent.toDouble(),
        title: 'Xuất sắc: ${data.excellent} SV',
        radius: 80,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge('Xuất sắc', Colors.green, data.excellent),
        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: Colors.blue, // Giỏi
        value: data.good.toDouble(),
        title: 'Giỏi: ${data.good} SV',
        radius: 75,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge('Giỏi', Colors.blue, data.good),
        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: Colors.orange, // Khá
        value: data.fair.toDouble(),
        title: 'Khá: ${data.fair} SV',
        radius: 70,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge('Khá', Colors.orange, data.fair),
        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: Colors.yellow, // Trung bình
        value: data.average.toDouble(),
        title: 'Trung bình: ${data.average} SV',
        radius: 65,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        badgeWidget: _buildBadge('Trung bình', Colors.yellow, data.average),
        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: Colors.purple, // Trung bình yếu
        value: data.belowAverage.toDouble(),
        title: 'Trung bình yếu: ${data.belowAverage} SV',
        radius: 60,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget:
            _buildBadge('Trung bình yếu', Colors.purple, data.belowAverage),
        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: Colors.red, // Kém
        value: data.fail.toDouble(),
        title: 'Kém: ${data.fail} SV',
        radius: 55,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge('Kém', Colors.red, data.fail),
        badgePositionPercentageOffset: 1.2,
      ),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phân bố điểm',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: showingSections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: showingSections.map((section) {
                return _buildLegend(section.title, section.color);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }

  Widget _buildBadge(String text, Color color, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$text: $count SV',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
