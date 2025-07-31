import 'package:flutter/material.dart';

import '../components/floatingactionset/expandable_fab.dart';

class FloatingButtonPage extends StatefulWidget {
  const FloatingButtonPage({super.key});

  @override
  State<FloatingButtonPage> createState() => _FloatingButtonPageState();
}

class _FloatingButtonPageState extends State<FloatingButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.defaultLocation,
      floatingActionButton: ExpandableFab(
        children: [
          FloatingActionButton.small(
            heroTag: "edit",
            child: Icon(Icons.edit),
            onPressed: () {},
          ),
          FloatingActionButton.small(
            heroTag: "search",
            child: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
