import 'package:flutter/material.dart';
import '../components/calender/calendar_component.dart';
import '../components/calender/event_model.dart';

class CalendarEventScreen extends StatelessWidget {
  const CalendarEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final sampleEvents = List<Event>.generate(10, (i) {
      final start = now.add(Duration(hours: i * 3));
      final end   = start.add(Duration(hours: 2 + (i % 3)));
      return Event(
        id: '$i',
        title: 'Event #${i + 1}',
        startDate: start,
        endDate: end,
        isContinuous: i % 4 == 0,
        isZeroTimeEvent: i % 3 == 0,
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar Events")),
      body: CalendarComponent<Event>(
        items: sampleEvents,
        startBuilder:  (e) => e.startDate,
        endBuilder:    (e) => e.endDate,
        titleBuilder:  (e) => e.title,
        labelBuilder:  (e) {
          if (e.isZeroTimeEvent) return 'Zero-time';
          if (e.isContinuous)  return 'Continuous';
          return 'Regular';
        },
        colorBuilder:  (e) {
          if (e.isZeroTimeEvent) return Colors.orange;
          if (e.isContinuous)  return Colors.green;
          return Colors.blue;
        },

        showMonth: true,
        showWeek:  true,
        showDay:   true,
        onDaySelected: (date) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected date: $date')),
          );
        },

        fetchEventsForDay: (date) async {
          // TODO: replace with real API call
          await Future.delayed(const Duration(seconds: 1));
          return <Event>[]; // parse from API
        },
      ),
    );
  }
}
