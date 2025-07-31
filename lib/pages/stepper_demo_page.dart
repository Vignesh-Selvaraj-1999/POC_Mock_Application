import 'package:flutter/material.dart';
import '../components/stepper/custom_stepper.dart';
import '../components/stepper/step_data.dart';

class StepperDemoPage extends StatelessWidget {
  StepperDemoPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Stepper Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomStepper(
          steps: [
            StepData(
              title: "Name",
              icon: Icons.person,
              formKey: GlobalKey<FormState>(),
              content: TextFormField(
                decoration: const InputDecoration(labelText: "Enter name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
            ),
            StepData(
              title: "Email",
              icon: Icons.email,
              formKey: GlobalKey<FormState>(),
              content: TextFormField(
                decoration: const InputDecoration(labelText: "Enter email"),
                validator: (v) => v != null && v.contains("@") ? null : "Invalid email",
              ),
            ),
            StepData(
              title: "Phone",
              icon: Icons.phone,
              formKey: GlobalKey<FormState>(),
              content: TextFormField(
                decoration: const InputDecoration(labelText: "Enter phone"),
                validator: (v) => v != null && v.length >= 10 ? null : "Invalid phone",
              ),
            ),
          ],
          onCompleted: () {
            print("🎉 All steps completed!");
          },
        ),
      ),
    );
  }
}
