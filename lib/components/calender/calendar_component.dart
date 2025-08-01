// lib/widgets/calendar_component.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateBuilder<T> = DateTime Function(T item);
typedef StringBuilder<T> = String Function(T item);
typedef ColorBuilder<T> = Color Function(T item);

/// Which view modes are available.
enum _CalendarView { day, week, month }

class CalendarComponent<T> extends StatefulWidget {
  /// Your raw items
  final List<T> items;

  /// How to get the start/end from each item
  final DateBuilder<T> startBuilder;
  final DateBuilder<T> endBuilder;

  /// How to get title/label/dot-color from each item
  final StringBuilder<T> titleBuilder;
  final StringBuilder<T> labelBuilder;
  final ColorBuilder<T> colorBuilder;

  /// Which tabs should be shown
  final bool showDay;
  final bool showWeek;
  final bool showMonth;

  /// Must show at least one
  CalendarComponent({
    super.key,
    required this.items,
    required this.startBuilder,
    required this.endBuilder,
    required this.titleBuilder,
    required this.labelBuilder,
    required this.colorBuilder,
    this.showDay = false,
    this.showWeek = false,
    this.showMonth = true,
  }) : assert(
         showDay || showWeek || showMonth,
         'You must enable at least one of showDay, showWeek or showMonth',
       );

  @override
  State<CalendarComponent<T>> createState() => _CalendarComponentState<T>();
}

class _CalendarComponentState<T> extends State<CalendarComponent<T>>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<_CalendarView> _views;
  late DateTime _focusedDay;
  late final List<T> _allItems;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Build the list of enabled views in order:
    _views = [
      if (widget.showDay) _CalendarView.day,
      if (widget.showWeek) _CalendarView.week,
      if (widget.showMonth) _CalendarView.month,
    ];
    _tabController = TabController(length: _views.length, vsync: this)
      ..addListener(() {
        setState(() => _selectedTabIndex = _tabController.index);
      });

    _focusedDay = DateTime.now();
    _allItems = widget.items;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<T> _filterItems(DateTime from, DateTime to) {
    return _allItems.where((item) {
      final start = widget.startBuilder(item);
      final end = widget.endBuilder(item);
      return start.isBefore(to.add(const Duration(days: 1))) &&
          end.isAfter(from.subtract(const Duration(days: 1)));
    }).toList();
  }

  Map<String, List<T>> _groupByDay(List<T> items) {
    final map = <String, List<T>>{};
    for (var item in items) {
      final key = DateFormat('yyyy-MM-dd').format(widget.startBuilder(item));
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  List<DateTime> _getCalendarDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final offset = first.weekday % 7;
    final total = offset + last.day;
    final weeks = (total / 7).ceil();
    return List.generate(weeks * 7, (i) {
      final day = i - offset + 1;
      return DateTime(month.year, month.month, day);
    });
  }

  List<DateTime> _getWeekDays(DateTime start) =>
      List.generate(7, (i) => start.add(Duration(days: i)));

  _CalendarView get _currentView => _views[_selectedTabIndex];

  String _headerText() {
    switch (_currentView) {
      case _CalendarView.day:
        return DateFormat.yMMMMEEEEd().format(_focusedDay);
      case _CalendarView.week:
        final end = _focusedDay.add(const Duration(days: 6));
        if (_focusedDay.month == end.month) {
          return '${DateFormat.MMMMd().format(_focusedDay)}–${DateFormat.d().format(end)}, ${_focusedDay.year}';
        } else {
          return '${DateFormat.MMMMd().format(_focusedDay)}–${DateFormat.MMMMd().format(end)}, ${_focusedDay.year}';
        }
      case _CalendarView.month:
      default:
        return DateFormat.yMMMM().format(_focusedDay);
    }
  }

  Widget _buildCalendarGrid(List<DateTime> days, Map<String, List<T>> grouped) {
    const weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Column(
      children: [
        // navigation header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    if (_currentView == _CalendarView.month) {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                      );
                    } else if (_currentView == _CalendarView.week) {
                      _focusedDay = _focusedDay.subtract(
                        const Duration(days: 7),
                      );
                    } else {
                      _focusedDay = _focusedDay.subtract(
                        const Duration(days: 1),
                      );
                    }
                  });
                },
              ),
              Text(
                _headerText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    if (_currentView == _CalendarView.month) {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                      );
                    } else if (_currentView == _CalendarView.week) {
                      _focusedDay = _focusedDay.add(const Duration(days: 7));
                    } else {
                      _focusedDay = _focusedDay.add(const Duration(days: 1));
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // weekday labels
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: weekdayLabels
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: days.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _currentView == _CalendarView.day ? 1 : 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: _currentView == _CalendarView.day ? 8 : 1,
          ),
          itemBuilder: (_, i) {
            final day = days[i];
            final key = DateFormat('yyyy-MM-dd').format(day);
            final evts = grouped[key] ?? [];
            final isThisMonth =
                _currentView != _CalendarView.month ||
                day.month == _focusedDay.month;
            final isToday = DateUtils.isSameDay(day, DateTime.now());
            final isFocused = DateUtils.isSameDay(day, _focusedDay);

            return GestureDetector(
              onTap: () {
                setState(() => _focusedDay = day);
                if (!widget.showDay) {
                } else {
                  if (_currentView != _CalendarView.day) {
                    _tabController.animateTo(
                      _views.indexOf(_CalendarView.day),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  color: isFocused
                      ? Colors.deepPurple.shade100
                      : isToday
                      ? Colors.blue.shade50
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentView == _CalendarView.day
                          ? DateFormat('EEE, MMM d').format(day)
                          : '${day.day}',
                      style: TextStyle(
                        fontSize: _currentView == _CalendarView.day ? 16 : 14,
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isThisMonth ? Colors.black : Colors.grey,
                      ),
                    ),
                    if (evts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 2,
                          runSpacing: 2,
                          children: evts.take(3).map((item) {
                            return Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: widget.colorBuilder(item),
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
      ],
    );
  }

  Widget _buildListView(List<T> items) {
    if (items.isEmpty) return const Center(child: Text("No items"));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        final s = DateFormat.yMMMd().add_Hm().format(widget.startBuilder(it));
        final e = DateFormat.yMMMd().add_Hm().format(widget.endBuilder(it));
        return Card(
          color: widget.colorBuilder(it),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(widget.titleBuilder(it)),
            subtitle: Text("$s → $e"),
            trailing: Text(widget.labelBuilder(it)),
          ),
        );
      },
    );
  }

  Widget _buildGroupedView(Map<String, List<T>> grouped) {
    if (grouped.isEmpty) return const Center(child: Text("No items"));
    return ListView(
      children: grouped.entries.map((ent) {
        final date = DateTime.parse(ent.key);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                DateFormat.yMMMMEEEEd().format(date),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...ent.value.map((it) {
              final s = DateFormat.Hm().format(widget.startBuilder(it));
              final e = DateFormat.Hm().format(widget.endBuilder(it));
              return Card(
                color: widget.colorBuilder(it),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(widget.titleBuilder(it)),
                  subtitle: Text("$s → $e"),
                  trailing: Text(widget.labelBuilder(it)),
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // choose the correct date range and day list:
    late final DateTime startDate, endDate;
    late final List<DateTime> days;

    switch (_currentView) {
      case _CalendarView.month:
        startDate = DateTime(_focusedDay.year, _focusedDay.month, 1);
        endDate = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
        days = _getCalendarDays(_focusedDay);
        break;
      case _CalendarView.week:
        startDate = _focusedDay;
        endDate = _focusedDay.add(const Duration(days: 6));
        days = _getWeekDays(_focusedDay);
        break;
      case _CalendarView.day:
      default:
        startDate = _focusedDay;
        endDate = _focusedDay;
        days = [_focusedDay];
        break;
    }

    final filtered = _filterItems(startDate, endDate);
    final grouped = _groupByDay(filtered);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _views.map((v) {
            switch (v) {
              case _CalendarView.day:
                return const Tab(text: 'Day');
              case _CalendarView.week:
                return const Tab(text: 'Week');
              case _CalendarView.month:
                return const Tab(text: 'Month');
            }
          }).toList(),
        ),
        _buildCalendarGrid(days, grouped),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _views.map((v) {
              switch (v) {
                case _CalendarView.day:
                  return _buildListView(filtered);
                case _CalendarView.week:
                case _CalendarView.month:
                  return _buildGroupedView(grouped);
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}
