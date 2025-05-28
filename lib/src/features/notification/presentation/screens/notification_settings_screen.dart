import 'package:flutter/material.dart';

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
    // Add other states as needed
    'group_notify': true,
    'schedule_daily': true,
    'calls_incoming': false, // Based on the image
    'events_notify': true,
    'in_app_preview': true,
    'in_app_vibrate': false, // Based on the image
  };

  void _toggleNotification(String key, bool value) {
    setState(() {
      _notificationStates[key] = value;
    });
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
                color: Colors.green.shade700, // Green color from image
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
                      value: _notificationStates[key] ??
                          false, // Default to false if key not found
                      onChanged: (bool value) {
                        _toggleNotification(key, value);
                      },
                      activeColor:
                          Colors.green, // Green color for active switch
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
          // Add other notification categories here
          _buildNotificationCategory(
            title: 'Group conversations',
            options: [
              {
                'key': 'group_notify',
                'description':
                    'Notify new messages from 2-person conversations', // Text seems identical to 2-person notify in image
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
                'description':
                    'Thông báo sự kiện gì đó chưa nghĩ ra', // Text from image
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
        ],
      ),
    );
  }
}
