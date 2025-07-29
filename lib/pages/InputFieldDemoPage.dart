import 'package:flutter/material.dart';
import '../components/input_field/input_field.dart';
import '../components/input_field/input_field_config.dart';

class InputFieldDemoPage extends StatelessWidget {
  const InputFieldDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Input Field Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // 🟡 Outlined Input Field
              InputField(
                config: InputFieldConfig(
                  controller: nameController,
                  hint: "Enter your name",
                  label: "Name",
                  variant: InputFieldVariant.outlined,
                  isRequired: true,
                  borderColor: Colors.deepPurple,
                  borderWidth: 1.5,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 🔵 Primary Input Field
              InputField(
                config: InputFieldConfig(
                  hint: "Enter your email",
                  label: "Email",
                  variant: InputFieldVariant.primary,
                  controller: TextEditingController(),
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.mail_outline),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Submit Button
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final name = nameController.text.trim();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Form valid. Name: $name")),
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
