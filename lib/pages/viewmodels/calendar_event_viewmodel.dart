import '../../components/calender/event_model.dart';

class CalendarEventViewModel {
  /// Holds all our events
  final List<Event> events = [];

  /// Last-tapped day (if you ever need it)
  DateTime selectedDate = DateTime.now();

  /// Generate some sample events
  void loadSampleEvents() {
    final now = DateTime.now();
    events.clear();
    for (var i = 0; i < 10; i++) {
      final start = now.add(Duration(hours: i * 3));
      final end   = start.add(Duration(hours: 2 + (i % 3)));
      events.add(Event(
        id: '$i',
        title: 'Event #${i + 1}',
        startDate: start,
        endDate: end,
        isContinuous:    i % 4 == 0,
        isZeroTimeEvent: i % 3 == 0,
      ));
    }
  }

  /// Called by the view when a day is tapped
  void onDaySelected(DateTime date) {
    selectedDate = date;
    // you could also filter locally or trigger an API call here
  }

  /// Used by CalendarComponent to fetch events for a single day
  Future<List<Event>> fetchEventsForDay(DateTime date) async {
    await Future.delayed(const Duration(seconds: 1));
    return events.where((e) =>
    e.startDate.year  == date.year  &&
        e.startDate.month == date.month &&
        e.startDate.day   == date.day
    ).toList();
  }
}
