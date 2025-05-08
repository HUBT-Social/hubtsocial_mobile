import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../../../router/router.import.dart';

enum TimetableType { Study, Exam, Seminar, RetakeExam }

extension TimetableTypeExtension on TimetableType {
  Color get color {
    switch (this) {
      case TimetableType.Study:
        return navigatorKey.currentContext != null
            ? navigatorKey.currentContext!.colorScheme.primary
            : Colors.blue;
      case TimetableType.Exam:
        return navigatorKey.currentContext != null
            ? navigatorKey.currentContext!.colorScheme.error
            : Colors.red;
      case TimetableType.Seminar:
        return navigatorKey.currentContext != null
            ? navigatorKey.currentContext!.colorScheme.tertiary
            : Colors.green;
      case TimetableType.RetakeExam:
        return navigatorKey.currentContext != null
            ? navigatorKey.currentContext!.colorScheme.error
            : Colors.red;
    }
  }
}
