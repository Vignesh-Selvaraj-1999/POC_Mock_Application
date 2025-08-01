import 'package:flutter/material.dart';
import '../components/calender/calendar_component.dart';
import '../components/calender/event_model.dart';

class CalendarEventScreen extends StatelessWidget {
  const CalendarEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // generate 10 sample events
    final now = DateTime.now();
    final sampleEvents = List<Event>.generate(10, (i) {
      final start = now.add(Duration(hours: i * 3));
      final end   = start.add(Duration(hours: 2 + (i % 3)));
      return Event(
        id: '$i',
        title: 'Event #${i + 1}',
        startDate: start,
        endDate: end,
        isContinuous: i % 4 == 0,        // every 4th event is continuous
        isZeroTimeEvent: i % 3 == 0,     // every 3rd event is zero-time
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar Events")),
      body: CalendarComponent<Event>(
        items: sampleEvents,
        startBuilder: (e) => e.startDate,
        endBuilder:   (e) => e.endDate,
        titleBuilder: (e) => e.title,
        labelBuilder: (e) => e.label,
        colorBuilder: (e) => e.backgroundColor,

        // only Month & Day tabs:
        showDay:   true,
        showWeek:  true,
        showMonth: true,
      )

    );
  }
}
