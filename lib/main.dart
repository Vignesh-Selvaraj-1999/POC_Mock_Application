import 'package:flutter/material.dart';
import 'package:listview_mock_application/pages/ButtonDemoScreen.dart';
import 'package:listview_mock_application/pages/EventCalendarScreen.dart';
import 'package:listview_mock_application/pages/InputFieldDemoPage.dart';
import 'package:listview_mock_application/pages/floatingButton_page.dart';
import 'package:listview_mock_application/pages/stepper_demo_page.dart';
import 'pages/first_screen.dart';
import 'pages/dropdown_test_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paginated Dropdown Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // land on FirstScreen, jump to DropdownTestScreen with a named route
      initialRoute: '/',
      routes: {
        '/':         (_) => const FirstScreen(),
        '/dropdown': (_) => const DropdownTestScreen(),
        '/button' : (_) => const ButtonDemoScreen(),
        "/event_calendar": (_) => const CalendarEventScreen(),
        "/input_field_demo": (_) => const InputFieldDemoPage(),
        "/stepper_demo": (_) => StepperDemoPage(),
        "/floating_button": (_) => const FloatingButtonPage(),
      },
    );
  }
}
