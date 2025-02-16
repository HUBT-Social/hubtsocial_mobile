import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../services/schedule_notification_service.dart';
import 'dart:async';

class ScheduleScreen extends StatefulWidget {
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleNotificationService _notificationService =
      ScheduleNotificationService();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initSchedule();
  }

  void _initSchedule() {
    // Lần đầu load lịch học
    _loadScheduleAndSetNotifications();

    // Tự động cập nhật lịch học mỗi 6 tiếng
    _refreshTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      _loadScheduleAndSetNotifications();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadScheduleAndSetNotifications() async {
    try {
      // TODO: Thay thế bằng API call thực tế
      List<ClassSchedule> schedules = await _fetchSchedules();
      await _notificationService.scheduleClassNotifications(schedules);
    } catch (e) {
      print('Lỗi khi cập nhật lịch học: $e');
    }
  }

  Future<List<ClassSchedule>> _fetchSchedules() async {
    // TODO: Thay thế bằng API call thực tế
    return [
      ClassSchedule(
        id: '1',
        name: 'Toán học',
        startTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      ClassSchedule(
        id: '2',
        name: 'Vật lý',
        startTime: DateTime.now().add(const Duration(hours: 4)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadScheduleAndSetNotifications,
          ),
        ],
      ),
      body: FutureBuilder<List<ClassSchedule>>(
        future: _fetchSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final schedules = snapshot.data ?? [];

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                title: Text(schedule.name),
                subtitle: Text(
                  'Thời gian: ${schedule.startTime.toString()}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
