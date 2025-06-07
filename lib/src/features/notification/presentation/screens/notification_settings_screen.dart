import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Map to store the state of notification toggles
  final Map<String, bool> _notificationStates = {
    '2_person_notify': true,
    '2_person_preview': true,
    'group_notify': true,
    'schedule_daily': true,
    'calls_incoming': false,
    'events_notify': true,
    'in_app_preview': true,
    'in_app_vibrate': false,
  };

  // Map to store blocked notification types
  final Map<String, bool> _blockedTypes = {
    'chat': false,
    'timetable': false,
    'broadcast': false,
    'maintenance': false,
    'academic_warning': false,
    'exam': false,
  };

  @override
  void initState() {
    super.initState();
    _loadBlockedTypes();
  }

  Future<void> _loadBlockedTypes() async {
    try {
      final box = await Hive.openBox('settings');
      final List<dynamic> blockedTypes =
          box.get('blocked_types', defaultValue: []);

      setState(() {
        for (var type in blockedTypes) {
          if (_blockedTypes.containsKey(type)) {
            _blockedTypes[type] = true;
          }
        }
      });
    } catch (e) {
      print('Error loading blocked types: $e');
    }
  }

  Future<void> _saveBlockedTypes() async {
    try {
      final box = await Hive.openBox('settings');
      final List<String> blockedTypes = _blockedTypes.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      await box.put('blocked_types', blockedTypes);
    } catch (e) {
      print('Error saving blocked types: $e');
    }
  }

  void _toggleNotification(String key, bool value) {
    setState(() {
      _notificationStates[key] = value;
    });
  }

  void _toggleBlockedType(String type, bool value) {
    setState(() {
      _blockedTypes[type] = value;
    });
    _saveBlockedTypes();
  }

  Widget _buildNotificationCategory({
    required String title,
    required List<Map<String, dynamic>> options,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              children: options.map((option) {
                final String key = option['key'];
                final String description = option['description'];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Switch(
                      value: _notificationStates[key] ?? false,
                      onChanged: (bool value) {
                        _toggleNotification(key, value);
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedTypesCategory() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chặn thông báo theo loại',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              children: _blockedTypes.entries.map((entry) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getTypeDescription(entry.key),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Switch(
                      value: entry.value,
                      onChanged: (bool value) {
                        _toggleBlockedType(entry.key, value);
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeDescription(String type) {
    switch (type) {
      case 'chat':
        return 'Chặn thông báo chat';
      case 'timetable':
        return 'Chặn thông báo lịch học';
      case 'broadcast':
        return 'Chặn thông báo phát sóng';
      case 'maintenance':
        return 'Chặn thông báo bảo trì';
      case 'academic_warning':
        return 'Chặn thông báo cảnh báo học tập';
      case 'exam':
        return 'Chặn thông báo thi cử';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildNotificationCategory(
            title: '2- person conversations',
            options: [
              {
                'key': '2_person_notify',
                'description':
                    'Notify new messages from 2-person conversations',
              },
              {
                'key': '2_person_preview',
                'description': 'Preview messages from 2-person conversations',
              },
            ],
          ),
          _buildNotificationCategory(
            title: 'Group conversations',
            options: [
              {
                'key': 'group_notify',
                'description':
                    'Notify new messages from 2-person conversations',
              },
            ],
          ),
          _buildNotificationCategory(
            title: 'Schedule',
            options: [
              {
                'key': 'schedule_daily',
                'description': 'Daily schedule announcement',
              },
            ],
          ),
          _buildNotificationCategory(
            title: 'Calls',
            options: [
              {
                'key': 'calls_incoming',
                'description': 'Notify incoming calls',
              },
            ],
          ),
          _buildNotificationCategory(
            title: 'Events',
            options: [
              {
                'key': 'events_notify',
                'description': 'Thông báo sự kiện gì đó chưa nghĩ ra',
              },
            ],
          ),
          _buildNotificationCategory(
            title: 'In-app notifications',
            options: [
              {
                'key': 'in_app_preview',
                'description': 'Preview new messages inside app',
              },
              {
                'key': 'in_app_vibrate',
                'description': 'Vibrate inside App when a new message arrives',
              },
            ],
          ),
          _buildBlockedTypesCategory(),
        ],
      ),
    );
  }
}
