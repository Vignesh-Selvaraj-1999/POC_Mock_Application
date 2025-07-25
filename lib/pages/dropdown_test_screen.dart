import 'dart:async';
import 'package:flutter/material.dart';
import '../components/generic_paginated_dropdown.dart';   // our very small demo implementation

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
    const valueFromApi = 'Name 39';
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
          .where((n) => n.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    final start = (page - 1) * 10;
    final end   = (start + 10).clamp(0, allNames.length);
    if (start >= allNames.length) return [];
    return allNames.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _loadInitialSelection();
  }

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
          SizedBox(
            height: 600,
            width: double.infinity,
            child: GenericPaginatedDropdown<String>(
              selectedItem: _selectedName,
              searchable: true,
              fetchItems: _fetchNames,
              onChanged: (value) => setState(() => _selectedName = value),
              itemLabel: (s) => s,
              hintText: 'Select a name',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose a name (multi-select)',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  GenericPaginatedDropdown<String>(
                    multiSelect: true,
                    selectedItem: _selectedName,
                    searchable: true,
                    fetchItems: _fetchNames,
                    onChanged: (value) => setState(() => _selectedName = value),
                    itemLabel: (s) => s,
                    hintText: 'Select a name',
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
