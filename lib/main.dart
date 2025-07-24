// main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listview_mock_application/widget.dart';

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

  Future<void> _loadInitialSelection() async {
    await Future.delayed(const Duration(seconds: 1));
    final String valueFromApi = 'Name 39';
    setState(() {
      _selectedName = valueFromApi;
      _loadingInitial = false;
    });
  }

  Future<List<String>> _fetchNames(int page, String? search) async {
    await Future.delayed(const Duration(milliseconds: 500));
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
  List<String> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    if (_loadingInitial) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paginated Dropdown Test'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Red area to match your design
          Container(
            height: 300,
            color: Colors.green,
            width: double.infinity,
            child:   GenericPaginatedDropdown<String>(
              selectedItem: _selectedName,
              searchable: true,
              fetchItems: _fetchNames,
              onChanged: (value) => setState(() => _selectedName = value),
              itemLabel: (s) => s,
              hintText: 'Select a name',
            ),
          ),
          // Blue area with dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose a name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GenericPaginatedDropdown<String>(
                    selectedItem: _selectedName,
                    searchable: true,
                    fetchItems: _fetchNames,
                    onChanged: (value) => setState(() => _selectedName = value),
                    itemLabel: (s) => s,
                    hintText: 'Select a name',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Selected Items: $selectedItems');
                      // Or access via dropdown key:
                      // print('Selected Items: ${dropdownKey.currentState?.selectedItems}');
                    },
                    child: Text('Print Selected Items (${selectedItems.length})'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}