import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open dropdown page'),
              onPressed: () => Navigator.pushNamed(context, '/dropdown'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Open button demo page'),
              onPressed: () => Navigator.pushNamed(context, '/button'),
            ),
          ],
        ),
      ),
    );
  }
}
