import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/timetable/models/class_schedule.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final List<String> weekDays = ['2', '3', '4', '5', '6', '7', 'CN'];
  final List<String> sessions = ['SÁNG', 'CHIỀU', 'TỐI'];
  Box<ClassSchedule>? _box;

  @override
  void initState() {
    super.initState();
    _initBox();
  }

  Future<void> _initBox() async {
    try {
      if (!Hive.isBoxOpen('class_schedules')) {
        _box = await Hive.openBox<ClassSchedule>('class_schedules');
      } else {
        _box = Hive.box<ClassSchedule>('class_schedules');
      }
      if (mounted) setState(() {});
    } catch (e) {
      print('Error initializing box: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_box == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.loc.timetable)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.timetable,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await _initBox();
                setState(() {});
              },
            ),
          ],
        )
      ],
      body: ValueListenableBuilder<Box<ClassSchedule>>(
        valueListenable: _box!.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text('Chưa có lịch học nào'),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                _buildTimetable(box),
                _buildLegend(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: context.colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HỌC KỲ II, NĂM HỌC 2024 - 2025',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'LỚP: TH27.29 - KHÓA: 27 - NGÀNH: TIN HỌC',
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTimetable(Box<ClassSchedule> box) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...weekDays.map((day) => _buildDayRow(day, box)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          _buildCell('THỨ', flex: 1),
          _buildCell('BUỔI', flex: 1),
          _buildCell('MÔN HỌC', flex: 3),
          _buildCell('PHÒNG', flex: 1),
          _buildCell('ID ZOOM', flex: 2),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day, Box<ClassSchedule> box) {
    final daySchedules = box.values
        .where((schedule) => schedule.weekDay == weekDays.indexOf(day) + 2)
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.colorScheme.outline),
        ),
      ),
      child: Row(
        children: [
          _buildCell(day, flex: 1),
          Expanded(
            flex: 7,
            child: Column(
              children: sessions.map((session) {
                final sessionSchedules = daySchedules
                    .where((schedule) => schedule.session == session)
                    .toList();

                return _buildSessionCell(session, sessionSchedules);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCell(String session, List<ClassSchedule> schedules) {
    if (schedules.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.colorScheme.outline),
          ),
        ),
        child: Row(
          children: [
            _buildCell(session, flex: 1),
            _buildCell('', flex: 3),
            _buildCell('', flex: 1),
            _buildCell('', flex: 2),
          ],
        ),
      );
    }

    return Column(
      children: schedules.map((schedule) {
        final isOngoing = schedule.isOngoing;
        final isUpcoming = schedule.isUpcoming;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isOngoing
                ? context.colorScheme.primaryContainer.withOpacity(0.3)
                : isUpcoming
                    ? context.colorScheme.tertiaryContainer.withOpacity(0.3)
                    : null,
            border: Border(
              top: BorderSide(color: context.colorScheme.outline),
            ),
          ),
          child: Row(
            children: [
              _buildCell(session, flex: 1),
              _buildCell(schedule.subject, flex: 3),
              _buildCell(schedule.room, flex: 1),
              _buildZoomCell(schedule.zoomId, flex: 2),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildZoomCell(String? zoomId, {int flex = 1}) {
    if (zoomId == null) return _buildCell('', flex: flex);

    return Expanded(
      flex: flex,
      child: TextButton(
        onPressed: () => _launchZoom(zoomId),
        child: Text(
          zoomId,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chú thích:',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildLegendItem(
            'Đang diễn ra',
            context.colorScheme.primaryContainer.withOpacity(0.3),
          ),
          const SizedBox(height: 4),
          _buildLegendItem(
            'Sắp diễn ra (trong 30 phút tới)',
            context.colorScheme.tertiaryContainer.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: context.colorScheme.outline),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: context.textTheme.bodySmall),
      ],
    );
  }

  Future<void> _launchZoom(String zoomId) async {
    final url = 'https://zoom.us/j/$zoomId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở Zoom')),
      );
    }
  }
}
