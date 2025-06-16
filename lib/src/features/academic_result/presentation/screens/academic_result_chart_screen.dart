import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/score_distribution_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_chart/academic_result_chart_bloc.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';

final class AcademicResultChartUtils {
  AcademicResultChartUtils._();

  static void showAcademicResultChartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      builder: (context) {
        return SizedBox(
          // height: ,
          child: BlocProvider(
            create: (context) => getIt<AcademicResultChartBloc>()
              ..add(GetAcademicResultChartEvent()),
            child: const _AcademicResultChartView(),
          ),
        );
      },
    );
  }
}

class _AcademicResultChartView extends StatelessWidget {
  const _AcademicResultChartView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: SafeArea(
        left: false,
        right: false,
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.left,
                'Biểu đồ phân tích',
                style: context.textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: 12.r),
            BlocBuilder<AcademicResultChartBloc, AcademicResultChartState>(
              builder: (context, state) {
                if (state is AcademicResultChartInitial) {
                  return const SizedBox();
                } else if (state is AcademicResultChartLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetAcademicResultChartSuccess) {
                  return _buildChart(context, state.model);
                } else if (state is AcademicResultChartError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<AcademicResultChartBloc>()
                                .add(GetAcademicResultChartEvent());
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, ScoreDistributionModel data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)),
            color: context.colorScheme.surface,
            shadowColor: context.colorScheme.shadow.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieChartSections(context, data),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Wrap(
                    spacing: 16.w,
                    runSpacing: 8.h,
                    children: _buildLegends(context, data),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      BuildContext context, ScoreDistributionModel data) {
    return [
      PieChartSectionData(
        color: Colors.yellow[700],
        value: data.excellent.toDouble(),
        title: '${data.excellent} SV',
        radius: 80,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.green[700],
        value: data.good.toDouble(),
        title: '${data.good} SV',
        radius: 75,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.blue[700],
        value: data.fair.toDouble(),
        title: '${data.fair} SV',
        radius: 70,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange[700],
        value: data.average.toDouble(),
        title: '${data.average} SV',
        radius: 65,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.purple[700],
        value: data.belowAverage.toDouble(),
        title: '${data.belowAverage} SV',
        radius: 60,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.red[700],
        value: data.fail.toDouble(),
        title: '${data.fail} SV',
        radius: 55,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  List<Widget> _buildLegends(
      BuildContext context, ScoreDistributionModel data) {
    return [
      _buildLegend('Xuất sắc', Colors.yellow[700]!, data.excellent),
      _buildLegend('Giỏi', Colors.green[700]!, data.good),
      _buildLegend('Khá', Colors.blue[700]!, data.fair),
      _buildLegend('Trung bình', Colors.orange[700]!, data.average),
      _buildLegend('Trung bình yếu', Colors.purple[700]!, data.belowAverage),
      _buildLegend('Kém', Colors.red[700]!, data.fail),
    ];
  }

  Widget _buildLegend(String title, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          color: color,
        ),
        SizedBox(width: 8.w),
        Text('$title: $count SV'),
      ],
    );
  }
}
