import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarEventScreen extends StatefulWidget {
  const CalendarEventScreen({super.key});

  @override
  State<CalendarEventScreen> createState() => _CalendarEventScreenState();
}

class _CalendarEventScreenState extends State<CalendarEventScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.utc(2025, 8, 4);
  List<Map<String, dynamic>> allEvents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadStaticEvents();
  }

  void loadStaticEvents() {
    final jsonData = <String, dynamic>{
      "talentEvent": [
        {
          "eventId": "5d1844a1-5188-477d-bbe3-8072ffc9dbc9",
          "title": "Multi Session Events 1",
          "eventStartDate": "2025-08-01T04:00:00Z",
          "eventEndDate": "2025-12-20T20:45:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-28T04:48:10.274Z",
          "updatedOn": "2025-07-28T04:48:10.353Z",
          "hasAttachment": null,
          "canSeeLabel": true,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-01T04:00:00Z",
              "endDate": "2025-08-02T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-08-08T04:00:00Z",
              "endDate": "2025-09-26T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-11-26T12:15:00Z",
              "endDate": "2025-12-20T20:45:00Z",
              "isZeroTimeEvent": false
            }
          ]
        },
        {
          "eventId": "70a9bca6-828b-4768-a352-4893abf46bbd",
          "title": "Multi Session Event 2",
          "eventStartDate": "2025-08-04T04:00:00Z",
          "eventEndDate": "2025-12-23T20:45:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-28T04:48:23.4Z",
          "updatedOn": "2025-07-28T04:48:23.57Z",
          "hasAttachment": null,
          "canSeeLabel": true,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-04T04:00:00Z",
              "endDate": "2025-08-05T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-08-11T04:00:00Z",
              "endDate": "2025-09-29T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-11-29T12:15:00Z",
              "endDate": "2025-12-23T20:45:00Z",
              "isZeroTimeEvent": false
            }
          ]
        },
        {
          "eventId": "aadd429f-2242-4f11-a54e-2cbee7beda4c",
          "title": "Multi Session Event 3",
          "eventStartDate": "2025-08-06T04:00:00Z",
          "eventEndDate": "2025-12-01T20:45:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-28T04:48:41.092Z",
          "updatedOn": "2025-07-28T04:48:41.183Z",
          "hasAttachment": null,
          "canSeeLabel": true,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-06T04:00:00Z",
              "endDate": "2025-08-07T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-08-13T04:00:00Z",
              "endDate": "2025-08-16T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-12-01T12:15:00Z",
              "endDate": "2025-12-01T20:45:00Z",
              "isZeroTimeEvent": false
            }
          ]
        },
        {
          "eventId": "6e112802-5ac3-4700-832c-9c26284c9dc1",
          "title": "Multi Session Event 4",
          "eventStartDate": "2025-08-07T04:00:00Z",
          "eventEndDate": "2025-12-26T20:45:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-28T04:49:38.284Z",
          "updatedOn": "2025-07-28T04:49:38.33Z",
          "hasAttachment": null,
          "canSeeLabel": true,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-07T04:00:00Z",
              "endDate": "2025-08-08T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-08-14T04:00:00Z",
              "endDate": "2025-10-02T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-12-02T12:15:00Z",
              "endDate": "2025-12-26T20:45:00Z",
              "isZeroTimeEvent": false
            }
          ]
        },
        {
          "eventId": "d9aba8ba-8d00-4a60-8a59-0fbb996c5f0a",
          "title": "Multi Session Event 3333",
          "eventStartDate": "2025-08-10T04:00:00Z",
          "eventEndDate": "2025-12-29T20:45:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-24T08:19:52.422Z",
          "updatedOn": "2025-07-24T08:19:52.487Z",
          "hasAttachment": null,
          "canSeeLabel": false,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-10T04:00:00Z",
              "endDate": "2025-08-11T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-08-17T04:00:00Z",
              "endDate": "2025-10-05T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-12-05T12:15:00Z",
              "endDate": "2025-12-29T20:45:00Z",
              "isZeroTimeEvent": false
            }
          ]
        },
        {
          "eventId": "ac4e1522-08f6-4308-aca3-b01cba9d18a0",
          "title": "Multi Session Event 22",
          "eventStartDate": "2025-08-16T04:00:00Z",
          "eventEndDate": "2025-12-28T20:45:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-24T08:19:37.085Z",
          "updatedOn": "2025-07-24T08:19:37.147Z",
          "hasAttachment": null,
          "canSeeLabel": false,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-16T04:00:00Z",
              "endDate": "2025-10-04T04:00:00Z",
              "isZeroTimeEvent": true
            },
            {
              "startDate": "2025-12-04T12:15:00Z",
              "endDate": "2025-12-28T20:45:00Z",
              "isZeroTimeEvent": false
            }
          ]
        },
        {
          "eventId": "4fadd711-0b9d-4477-ba6f-515fa9bd1de9",
          "title": "Multi days Test Event 5",
          "eventStartDate": "2025-08-16T04:00:00Z",
          "eventEndDate": "2025-10-04T04:00:00Z",
          "eventType": "Option LA",
          "publishStatus": "Re-Published",
          "publishStatusCode": 30,
          "publishedDate": "2025-07-28T05:36:07.092Z",
          "updatedOn": "2025-07-28T05:36:07.183Z",
          "hasAttachment": null,
          "canSeeLabel": true,
          "optionTypeId": 176196000,
          "eventTimes":
          [
            {
              "startDate": "2025-08-16T04:00:00Z",
              "endDate": "2025-10-04T04:00:00Z",
              "isZeroTimeEvent": true
            }
          ]
        },
        {
          "eventId": "87643360-52e1-4547-bb62-91d47b972e67",
          "title": "LA Job",
          "eventStartDate": "2025-08-04T10:15:00Z",
          "eventEndDate": "2025-08-04T14:15:00Z",
          "eventType": "Job LA",
          "publishedDate": "2025-07-23T11:18:34.691Z",
          "updatedOn": "2025-07-23T11:18:34.727Z",
          "isContinuous": true,
          "hasAttachment": null,
          "canSeeLabel": true,
          "optionTypeId": 0,
          "eventTimes":
          [
            {
              "startDate": "2025-08-04T10:15:00Z",
              "endDate": "2025-08-04T14:15:00Z",
              "isZeroTimeEvent": false
            }
          ]
        }
      ]
    };

    final events = jsonData["talentEvent"] as List;

    allEvents = events.expand<Map<String, dynamic>>((event) {
      final times = event["eventTimes"] as List;
      return times.map((t) => {
        "title": event["title"],
        "eventId": event["eventId"],
        "isContinuous": event["isContinuous"] ?? false,
        "isZeroTimeEvent": t["isZeroTimeEvent"],
        "startDate": DateTime.parse(t["startDate"]),
        "endDate": DateTime.parse(t["endDate"]),
      });
    }).toList();
  }

  List<Map<String, dynamic>> filterEvents(DateTime from, DateTime to) {
    final filtered = allEvents.where((e) {
      final start = e["startDate"] as DateTime;
      final end = e["endDate"] as DateTime;
      return start.isBefore(to.add(const Duration(days: 1))) &&
          end.isAfter(from.subtract(const Duration(days: 1)));
    }).toList();

    // Now sort by group, then startDate, then title
    filtered.sort((a, b) {
      int groupA = a["isContinuous"] == true
          ? 0
          : (a["isZeroTimeEvent"] == true ? 1 : 2);
      int groupB = b["isContinuous"] == true
          ? 0
          : (b["isZeroTimeEvent"] == true ? 1 : 2);
      if (groupA != groupB) return groupA.compareTo(groupB);

      final dateA = a["startDate"] as DateTime;
      final dateB = b["startDate"] as DateTime;
      if (!dateA.isAtSameMomentAs(dateB)) {
        return dateA.compareTo(dateB);
      }

      return (a["title"] ?? "").compareTo(b["title"] ?? "");
    });

    return filtered;
  }


  Map<String, List<Map<String, dynamic>>> groupByDay(
      List<Map<String, dynamic>> events) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final e in events) {
      final key = DateFormat('yyyy-MM-dd').format(e["startDate"]);
      grouped.putIfAbsent(key, () => []).add(e);
    }
    return grouped;
  }

  Color getColor(Map e) {
    if (e["isContinuous"] == true) return Colors.orange.shade100;
    if (e["isZeroTimeEvent"] == true) return Colors.blue.shade100;
    return Colors.green.shade100;
  }

  String label(Map e) {
    if (e["isContinuous"] == true) return "Continuous";
    if (e["isZeroTimeEvent"] == true) return "Multi-day";
    return "Timed";
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = _focusedDay;
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Events"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Day"), Tab(text: "Week"), Tab(text: "Month")],
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2025, 8, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(d, _focusedDay),
            onDaySelected: (d, _) => setState(() => _focusedDay = d),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Day View
                buildList(filterEvents(_focusedDay, _focusedDay)),
                // Week View
                buildGrouped(groupByDay(filterEvents(startOfWeek, endOfWeek))),
                // Month View
                buildGrouped(groupByDay(filterEvents(startOfMonth, endOfMonth))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList(List<Map<String, dynamic>> events) {
    if (events.isEmpty) return const Center(child: Text("No events"));
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (_, i) {
        final e = events[i];
        final start = DateFormat("MMM d, HH:mm").format(e["startDate"]);
        final end = DateFormat("MMM d, HH:mm").format(e["endDate"]);
        return Card(
          color: getColor(e),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(e["title"]),
            subtitle: Text("$start → $end"),
            trailing: Text(label(e)),
          ),
        );
      },
    );
  }

  Widget buildGrouped(Map<String, List<Map<String, dynamic>>> grouped) {
    if (grouped.isEmpty) return const Center(child: Text("No events"));
    return ListView(
      children: grouped.entries.map((entry) {
        final date = entry.key;
        final items = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                DateFormat("EEEE, MMM d").format(DateTime.parse(date)),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...items.map((e) {
              final start = DateFormat("HH:mm").format(e["startDate"]);
              final end = DateFormat("HH:mm").format(e["endDate"]);
              return Card(
                color: getColor(e),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(e["title"]),
                  subtitle: Text("$start → $end"),
                  trailing: Text(label(e)),
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}