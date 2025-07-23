import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom DropdownStack App',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedFruit = 'Apple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Dropdown with Search'),
        backgroundColor: Colors.blue,
      ),
      body: SearchDropdownListStack(
        dropdownItems: const ['Apple', 'Banana', 'Mango', 'Orange', 'Grape', 'Pineapple', 'Strawberry'],
        selectedItem: selectedFruit,
        onDropdownChanged: (value) => setState(() => selectedFruit = value),
        listTiles: List.generate(
          20,
              (index) => ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('List Item ${index + 1}'),
            subtitle: Text('Subtitle for item ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on Item ${index + 1}')),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SearchDropdownListStack extends StatefulWidget {
  final List<String> dropdownItems;
  final List<Widget> listTiles;
  final String labelText;
  final ValueChanged<String?>? onDropdownChanged;
  final String? selectedItem;

  const SearchDropdownListStack({
    super.key,
    required this.dropdownItems,
    required this.listTiles,
    this.labelText = "Choose an option",
    this.onDropdownChanged,
    this.selectedItem,
  });

  @override
  State<SearchDropdownListStack> createState() => _SearchDropdownListStackState();
}

class _SearchDropdownListStackState extends State<SearchDropdownListStack> {
  bool dropdownOpen = false;
  late TextEditingController searchController;
  late List<String> filteredItems;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredItems = List.from(widget.dropdownItems);
  }

  void _toggleDropdown() {
    setState(() {
      dropdownOpen = !dropdownOpen;
      if (!dropdownOpen) {
        searchController.clear();
        filteredItems = List.from(widget.dropdownItems);
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredItems = widget.dropdownItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSelectItem(String item) {
    widget.onDropdownChanged?.call(item);
    searchController.clear();
    filteredItems = List.from(widget.dropdownItems);
    setState(() => dropdownOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.labelText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.selectedItem ?? 'Select an option',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    dropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Dropdown content
          if (dropdownOpen) ...[
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search field
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),

                  // Dropdown items
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return InkWell(
                          onTap: () => _onSelectItem(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
