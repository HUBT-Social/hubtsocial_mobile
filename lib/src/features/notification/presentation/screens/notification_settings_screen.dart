import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Map to store blocked notification types
  final Map<String, bool> _blockedTypes = {
    'chat': false,
    'schedule': false,
    'broadcast': false,
    'maintenance': false,
    'academic_warning': false,
    'exam': false,
    'group': false,
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

  void _toggleBlockedType(String type, bool value) {
    setState(() {
      _blockedTypes[type] = value;
    });
    _saveBlockedTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.notificationSettingsTitle,
          style: context.textTheme.headlineMedium
              ?.copyWith(color: context.colorScheme.onPrimary),
        ),
        backgroundColor: context.colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colorScheme.primary.withOpacity(0.1),
              context.colorScheme.surface,
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 50.h), // Added top padding
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              // child: Text(
              //   // context.loc.blockedNotificationTypesTitle,
              //   style: context.textTheme.titleLarge
              //       ?.copyWith(color: context.colorScheme.onSurface.withOpacity(0.8)),
              // ),
            ),
            // Generate a Card for each blocked notification type
            ..._blockedTypes.entries.map((entry) {
              return _buildBlockedTypeCard(entry.key, entry.value, context);
            }),
            SizedBox(height: 50.h), // Added bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedTypeCard(String type, bool value, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: context.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _getTypeDescription(type, context),
                style: context.textTheme.labelLarge
                    ?.copyWith(color: context.colorScheme.onSurface),
              ),
            ),
            Switch(
              value: value,
              onChanged: (bool newValue) {
                _toggleBlockedType(type, newValue);
              },
              activeColor: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeDescription(String type, BuildContext context) {
    switch (type) {
      case 'chat':
        return context.loc.blockChatNotifications;
      case 'schedule':
        return context.loc.blockTimetableNotifications;
      case 'broadcast':
        return context.loc.blockBroadcastNotifications;
      case 'maintenance':
        return context.loc.blockMaintenanceNotifications;
      case 'academic_warning':
        return context.loc.blockAcademicWarningNotifications;
      case 'exam':
        return context.loc.blockExamNotifications;
      case 'group':
        return context.loc.blockGroupNotifications;
      default:
        return type;
    }
  }
}
