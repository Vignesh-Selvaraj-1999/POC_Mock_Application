import 'package:flutter/material.dart';
import 'package:listview_mock_application/pages/viewmodels/calendar_event_viewmodel.dart';
import '../components/calender/calendar_component.dart';
import '../components/calender/event_model.dart';

class CalendarEventScreen extends StatefulWidget {
  const CalendarEventScreen({Key? key}) : super(key: key);

  @override
  _CalendarEventScreenState createState() => _CalendarEventScreenState();
}

class _CalendarEventScreenState extends State<CalendarEventScreen> {
  final _viewModel = CalendarEventViewModel();

  @override
  void initState() {
    super.initState();
    // populate our events once
    _viewModel.loadSampleEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar Events")),
      body: CalendarComponent<Event>(
        items:        _viewModel.events,
        startBuilder: (e) => e.startDate,
        endBuilder:   (e) => e.endDate,
        titleBuilder: (e) => e.title,
        labelBuilder: (e) {
          if (e.isZeroTimeEvent) return 'Zero-time';
          if (e.isContinuous)  return 'Continuous';
          return 'Regular';
        },
        colorBuilder: (e) {
          if (e.isZeroTimeEvent) return Colors.orange;
          if (e.isContinuous)  return Colors.green;
          return Colors.blue;
        },
        showMonth: true,
        showWeek:  true,
        showDay:   true,

        onDaySelected: (date) {
          // update VM and show a snackbar
          setState(() => _viewModel.onDaySelected(date));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected date: $date')),
          );
        },

        fetchEventsForDay: _viewModel.fetchEventsForDay,
      ),
    );
  }
}
