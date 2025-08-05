// lib/components/calender/calendar_component.dart

import 'package:flutter/material.dart';

typedef DateBuilder<T>   = DateTime Function(T item);
typedef StringBuilder<T> = String Function(T item);
typedef ColorBuilder<T>  = Color Function(T item);

/// Which view modes are available.
enum _CalendarView { month, week, day }

class CalendarComponent<T> extends StatefulWidget {
  final List<T> items;
  final DateBuilder<T> startBuilder, endBuilder;
  final StringBuilder<T> titleBuilder, labelBuilder;
  final ColorBuilder<T> colorBuilder;
  final bool showMonth, showWeek, showDay;
  final void Function(DateTime day)? onDaySelected;
  /// Called when a day is tapped; should return events for [day].
  final Future<List<T>> Function(DateTime day)? fetchEventsForDay;

  const CalendarComponent({
    Key? key,
    required this.items,
    required this.startBuilder,
    required this.endBuilder,
    required this.titleBuilder,
    required this.labelBuilder,
    required this.colorBuilder,
    this.showMonth = true,
    this.showWeek  = true,
    this.showDay   = false,
    this.onDaySelected,
    this.fetchEventsForDay,
  }) : assert(showMonth || showWeek || showDay),
        super(key: key);

  @override
  _CalendarComponentState<T> createState() => _CalendarComponentState<T>();
}

class _CalendarComponentState<T> extends State<CalendarComponent<T>>
    with SingleTickerProviderStateMixin {

  static const List<String> _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];
  static const List<String> _weekdayShort = [
    'Sun','Mon','Tue','Wed','Thu','Fri','Sat'
  ];
  static const List<String> _weekdayLong = [
    'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
  ];

  late final TabController         _formatController;
  late final PageController        _pageController;
  late final ValueNotifier<double> _heightNotifier;
  late final List<_CalendarView>   _views;

  DateTime _focusedDay = DateTime.now();

  /// Cache of fetched events, keyed by "yyyy-MM-dd"
  final Map<String, List<T>> _cachedEvents = {};

  /// Dates currently loading
  final Set<String> _loadingDates = {};

  @override
  void initState() {
    super.initState();
    _views = [
      if (widget.showMonth) _CalendarView.month,
      if (widget.showWeek ) _CalendarView.week,
      if (widget.showDay  ) _CalendarView.day,
    ];
    _formatController = TabController(length: _views.length, vsync: this)
      ..addListener(_onFormatChanged);
    _pageController   = PageController(initialPage: 0);
    _heightNotifier   = ValueNotifier(_computeHeight(_views[0]));
  }

  @override
  void dispose() {
    _formatController.dispose();
    _pageController.dispose();
    _heightNotifier.dispose();
    super.dispose();
  }

  void _onFormatChanged() {
    _heightNotifier.value = _computeHeight(_views[_formatController.index]);
  }

  double _computeHeight(_CalendarView view) {
    const dowHeight = 24.0;
    const rowHeight = 58.0;
    final rows = (view == _CalendarView.month) ? 6 : 1;
    return dowHeight + rows * rowHeight;
  }

  String _dayKey(DateTime d) => d.toIso8601String().substring(0,10);

  /// Fetch and merge initial + fetched events for a given day
  List<T> _eventsForDay(DateTime day) {
    final key = _dayKey(day);
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd   = dayStart.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    final base = widget.items.where((e) {
      final s = widget.startBuilder(e);
      final t = widget.endBuilder(e);
      return s.isBefore(dayEnd) && t.isAfter(dayStart);
    });
    final extra = _cachedEvents[key] ?? [];
    return [...base, ...extra];
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    final key = _dayKey(day);
    if (widget.fetchEventsForDay == null) return;
    if (_loadingDates.contains(key) || _cachedEvents.containsKey(key)) return;

    _loadingDates.add(key);
    setState(() {});

    try {
      final results = await widget.fetchEventsForDay!(day);
      _cachedEvents[key] = results;
    } catch (_) {
      // handle error
    } finally {
      _loadingDates.remove(key);
      setState(() {});
    }
  }

  List<DateTime> _getCalendarDays(DateTime month) {
    final first  = DateTime(month.year, month.month, 1);
    final last   = DateTime(month.year, month.month + 1, 0);
    final offset = first.weekday % 7;
    final total  = offset + last.day;
    final weeks  = (total / 7).ceil();
    return List.generate(weeks * 7, (i) {
      final d = i - offset + 1;
      return DateTime(month.year, month.month, d);
    });
  }

  String _formatMonthHeader(DateTime d) => '${_monthNames[d.month - 1]} ${d.year}';

  String _formatWeekHeader(DateTime start) {
    final end = start.add(const Duration(days: 6));
    String a = '${_monthNames[start.month - 1]} ${start.day}';
    String b = start.month == end.month
        ? '${end.day}'
        : '${_monthNames[end.month - 1]} ${end.day}';
    return '$a – $b, ${start.year}';
  }

  String _formatDayHeader(DateTime d) =>
      '${_weekdayLong[d.weekday % 7]}, ${_monthNames[d.month - 1]} ${d.day}, ${d.year}';

  String _headerText() {
    final view = _views[_formatController.index];
    switch (view) {
      case _CalendarView.month:
        return _formatMonthHeader(_focusedDay);
      case _CalendarView.week:
        return _formatWeekHeader(_focusedDay);
      case _CalendarView.day:
      default:
        return _formatDayHeader(_focusedDay);
    }
  }


  @override
  Widget build(BuildContext context) {
    final view = _views[_formatController.index];
    return Column(
      children: [
        // 1. Format tabs
        TabBar(
          controller: _formatController,
          tabs: _views.map((v) {
            switch (v) {
              case _CalendarView.month: return const Tab(text: 'Month');
              case _CalendarView.week:  return const Tab(text: 'Week');
              case _CalendarView.day:   return const Tab(text: 'Day');
            }
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    if (view == _CalendarView.month) {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                      );
                    } else if (view == _CalendarView.week) {
                      _focusedDay =
                          _focusedDay.subtract(const Duration(days: 7));
                    } else {
                      _focusedDay =
                          _focusedDay.subtract(const Duration(days: 1));
                    }
                  });
                },
              ),

              // Center header text
              Text(
                _headerText(), // returns the formatted Month/Week/Day header
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    if (view == _CalendarView.month) {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                      );
                    } else if (view == _CalendarView.week) {
                      _focusedDay =
                          _focusedDay.add(const Duration(days: 7));
                    } else {
                      _focusedDay =
                          _focusedDay.add(const Duration(days: 1));
                    }
                  });
                },
              ),
            ],
          ),
        ),
        // 2. Animated, swipeable calendar grid
        ValueListenableBuilder<double>(
          valueListenable: _heightNotifier,
          builder: (ctx, height, _) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: height,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      final fmt = _views[_formatController.index];
                      if (fmt == _CalendarView.month) {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month + page,
                        );
                      } else if (fmt == _CalendarView.week) {
                        _focusedDay =
                            _focusedDay.add(Duration(days: 7 * page));
                      } else {
                        _focusedDay =
                            _focusedDay.add(Duration(days: page));
                      }
                    });
                  },
                  itemBuilder: (_, page) {
                    final fmt = _views[_formatController.index];
                    List<DateTime> days;
                    if (fmt == _CalendarView.month) {
                      final m = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + page,
                      );
                      days = _getCalendarDays(m);
                    } else if (fmt == _CalendarView.week) {
                      final start =
                      _focusedDay.add(Duration(days: 7 * page));
                      days = List.generate(
                          7, (i) => start.add(Duration(days: i)));
                    } else {
                      days = [
                        _focusedDay.add(Duration(days: page))
                      ];
                    }

                    final grouped = <String, List<T>>{};
                    for (var d in days) {
                      grouped[_dayKey(d)] = _eventsForDay(d);
                    }

                    return _buildGrid(fmt, days, grouped);
                  },
                ),
              ),
            );
          },
        ),

        // 3. Detail list for the focused day
        Expanded(child: _buildDetailList()),
      ],
    );
  }

  Widget _buildGrid(
      _CalendarView fmt,
      List<DateTime> days,
      Map<String, List<T>> grouped,
      ) {
    String header;
    if (fmt == _CalendarView.month) {
      header = _formatMonthHeader(_focusedDay);
    } else if (fmt == _CalendarView.week) {
      header = _formatWeekHeader(_focusedDay);
    } else {
      header = _formatDayHeader(_focusedDay);
    }

    return Column(
      children: [
        Row(
          children: _weekdayShort
              .map((d) => Expanded(child: Center(child: Text(d))))
              .toList(),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
              fmt == _CalendarView.day ? 1 : 7,
              childAspectRatio:
              fmt == _CalendarView.day ? 8 : 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (_, i) {
              final day    = days[i];
              final key    = _dayKey(day);
              final evts   = grouped[key]!;
              final isToday  =
              DateUtils.isSameDay(day, DateTime.now());
              final isFocus  =
              DateUtils.isSameDay(day, _focusedDay);

              return GestureDetector(
                onTap: () {
                  setState(() => _focusedDay = day);
                  widget.onDaySelected?.call(day);

                  // always fetch once per date
                  if (widget.fetchEventsForDay != null &&
                      !_cachedEvents.containsKey(key)) {
                    _loadEventsForDay(day);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300),
                    color: isFocus
                        ? Colors.deepPurple.shade100
                        : isToday
                        ? Colors.blue.shade50
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(fmt == _CalendarView.day
                          ? '${_weekdayLong[day.weekday % 7]} '
                          '${_monthNames[day.month - 1]} ${day.day}'
                          : '${day.day}'),
                      if (evts.isNotEmpty)
                        Positioned(
                          bottom: 4,
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: evts
                                .take(3)
                                .map((e) {
                              return Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 1),
                                decoration: BoxDecoration(
                                  color: widget
                                      .colorBuilder(e),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailList() {
    final key = _dayKey(_focusedDay);

    if (_loadingDates.contains(key)) {
      return const Center(
          child: CircularProgressIndicator());
    }

    final evts = _eventsForDay(_focusedDay);
    if (evts.isEmpty) {
      return const Center(
          child: Text('No events. Tap a date to load.'));
    }

    return ListView(
      children: evts.map((e) {
        final s = widget.startBuilder(e);
        final t = widget.endBuilder(e);
        final sStr =
            '${s.hour.toString().padLeft(2,'0')}:'
            '${s.minute.toString().padLeft(2,'0')}';
        final tStr =
            '${t.hour.toString().padLeft(2,'0')}:'
            '${t.minute.toString().padLeft(2,'0')}';
        return Card(
          color: widget.colorBuilder(e),
          margin: const EdgeInsets.symmetric(
              vertical: 4, horizontal: 12),
          child: ListTile(
            title: Text(widget.titleBuilder(e)),
            subtitle: Text('$sStr → $tStr • ${widget.labelBuilder(e)}'),
            onTap: () => widget.onDaySelected?.call(_focusedDay),
          ),
        );
      }).toList(),
    );
  }
}