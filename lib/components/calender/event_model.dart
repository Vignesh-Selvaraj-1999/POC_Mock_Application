// lib/models/event_model.dart
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isContinuous;
  final bool isZeroTimeEvent;

  const Event({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isContinuous,
    required this.isZeroTimeEvent,
  });




  factory Event.fromJson(Map<String, dynamic> eventJson, Map<String, dynamic> timeJson, Map<String, String> schema) {
    return Event(
      id: eventJson[schema["eventIdKey"]] ?? '',
      title: eventJson[schema["titleKey"]] ?? 'Untitled',
      isContinuous: eventJson[schema["continuousKey"]] ?? false,
      isZeroTimeEvent: timeJson[schema["zeroTimeKey"]] ?? false,
      startDate: DateTime.tryParse(timeJson[schema["startKey"] ?? ""])?.toLocal() ?? DateTime.now(),
      endDate: DateTime.tryParse(timeJson[schema["endKey"] ?? ""])?.toLocal() ?? DateTime.now(),
    );
  }

  Color get backgroundColor {
    if (isContinuous) return Colors.orange.shade100;
    if (isZeroTimeEvent) return Colors.blue.shade100;
    return Colors.green.shade100;
  }

  String get label {
    if (isContinuous) return "Continuous";
    if (isZeroTimeEvent) return "Multi-day";
    return "Timed";
  }

  String get groupKey => "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
}
