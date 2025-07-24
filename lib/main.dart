import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listview_mock_application/widget.dart';
import 'font.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paginated Dropdown Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DropdownTestScreen(),
    );
  }
}

class DropdownTestScreen extends StatefulWidget {
  const DropdownTestScreen({super.key});

  @override
  State<DropdownTestScreen> createState() => _DropdownTestScreenState();
}

class _DropdownTestScreenState extends State<DropdownTestScreen> {
  String? _selectedName;
  bool _loadingInitial = true;
  final GlobalKey _vpKey = GlobalKey();

  // ──────────────────────────────────────────────────────────────────────────
  // 1️⃣  Simulate an API that tells us which value is currently selected.
  //     (Replace this with your real API call.)
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> _loadInitialSelection() async {
    await Future.delayed(const Duration(seconds: 2));
    final String valueFromApi = 'Name 39';
    setState(() {
      _selectedName = valueFromApi;
      _loadingInitial = false;
    });
  }

  Future<List<String>> _fetchNames(int page, String? search) async {
    await Future.delayed(const Duration(milliseconds: 800)); // network delay
    List<String> allNames = List.generate(100, (i) => 'Name ${i + 1}');
    if (search != null && search.isNotEmpty) {
      allNames = allNames
          .where((name) => name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    final int start = (page - 1) * 10;
    final int end = start + 10;
    if (start >= allNames.length) return [];
    return allNames.sublist(start, end.clamp(0, allNames.length));
  }

  @override
  void initState() {
    super.initState();
    _loadInitialSelection();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingInitial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Paginated Dropdown Test')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            key: _vpKey,
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: GenericPaginatedDropdown<String>(
              viewportKey: _vpKey,
              selectedItem: _selectedName,
              searchable: true,
              fetchItems: _fetchNames,
              onChanged: (value) => setState(() => _selectedName = value),
              itemLabel: (s) => s,
              hintText: 'Select a name',
              itemBuilder: (s) => Text(
                s,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              errorStyle: TextStyles.regularText(
                fontSize: 12,
                color: Colors.red,
              ),
              heading: const Text(
                // 👈  the optional heading
                'Choose a name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
