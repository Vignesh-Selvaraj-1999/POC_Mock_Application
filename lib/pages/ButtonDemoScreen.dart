import 'package:flutter/material.dart';

import '../components/custom_button..dart'; // ← fixed extra dot
import '../components/custom_toggle_button.dart';
import '../components/custom_toggle_switch.dart';

class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});
  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  bool _isLoading = false;

  // add the missing toggles
  bool _darkMode = false;
  bool _muted     = false;
  bool _isActive  = false;
  bool _wifi      = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomButton Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              text: 'Primary Button',
              icon: const Icon(Icons.send, color: Colors.white),
              iconPosition: IconPosition.end,
              onPressed: () => debugPrint('Primary pressed'),
              fullWidth: true,
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Loading Button',
              icon: const Icon(Icons.hourglass_empty, color: Colors.white),
              isLoading: _isLoading,
              onPressed: _isLoading
                  ? null
                  : () {
                setState(() => _isLoading = true);
                Future.delayed(const Duration(seconds: 2),
                        () => setState(() => _isLoading = false));
              },
              fullWidth: true,
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Disabled Button',
              icon: const Icon(Icons.block, color: Colors.white),
              onPressed: null,
              fullWidth: true,
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Gradient Button',
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.red],
              ),
              onPressed: () => debugPrint('Gradient pressed'),
              fullWidth: false,
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Save',
              shape: ButtonShape.stadium,
              borderRadius: 4,
              onPressed: () {},
            ),
            const SizedBox(height: 16),

            // toggle buttons ---------------------------------------------------
            CustomToggleButton(
              shape: ToggleShape.stadium,
              value: _darkMode,
              onText: 'Dark',
              offText: 'Light',
              onIcon: const Icon(Icons.nightlight_round, color: Colors.white),
              offIcon: const Icon(Icons.wb_sunny, color: Colors.yellow),
              onChanged: (v) => setState(() => _darkMode = v),
            ),
            const SizedBox(height: 16),

            CustomToggleButton(
              shape: ToggleShape.circle,
              value: _muted,
              onIcon: const Icon(Icons.volume_off, color: Colors.white),
              offIcon: const Icon(Icons.volume_up, color: Colors.white),
              onColor: Colors.red,
              offColor: Colors.blue,
              onChanged: (v) => setState(() => _muted = v),
            ),
            const SizedBox(height: 16),

            CustomToggleButton(
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wi-Fi'),
                  CustomToggleSwitch(
                  value: _wifi,
                  onChanged: (v) => setState(() => _wifi = v),
                  onTrackColor: Colors.blue,
                  offTrackColor: Colors.grey.shade400,
                  onThumbColor: Colors.white,
                  offThumbColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
