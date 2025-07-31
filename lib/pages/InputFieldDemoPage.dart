import 'package:flutter/material.dart';
import '../components/input_field/input_field.dart';
import '../components/input_field/input_field_config.dart';

class InputFieldDemoPage extends StatelessWidget {
  const InputFieldDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Input Field Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 🟡 Name Field
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

                // 🔵 Email Field
                InputField(
                  config: InputFieldConfig(
                    controller: emailController,
                    hint: "Enter your email",
                    label: "Email",
                    variant: InputFieldVariant.primary,
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
                const SizedBox(height: 24),

                // ☎️ Phone Number Field
                InputField(
                  config: InputFieldConfig(
                    controller: phoneController,
                    hint: "Enter your phone number",
                    label: "Phone Number",
                    variant: InputFieldVariant.outlined,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.trim().length != 10) {
                        return "Enter a valid 10-digit phone number";
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
                      final email = emailController.text.trim();
                      final phone = phoneController.text.trim();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Submitted: $name, $email, $phone"),
                        ),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
