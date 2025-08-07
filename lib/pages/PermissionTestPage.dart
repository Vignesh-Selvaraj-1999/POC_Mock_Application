import 'package:flutter/material.dart';

import '../components/permission_component/permision_component.dart';

class PermissionTestPage extends StatelessWidget {
  const PermissionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final status = await showPermissionDialog(
                  context,
                  AppPermission.camera,
                );
                if (status != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Camera Permission: $status')),
                  );
                }
              },
              child: const Text('Request Camera Permission'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final status = await showPermissionDialog(
                  context,
                  AppPermission.location,
                );
                if (status != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Location Permission: $status')),
                  );
                }
              },
              child: const Text('Request Location Permission'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final status = await showPermissionDialog(
                  context,
                  AppPermission.storage,
                );
                if (status != null) {
                  ScaffoldMessenger.of(context).showSnackBar(


                    SnackBar(content: Text('Storage Permission: $status')),
                  );
                }
              },
              child: const Text('Request Storage Permission'),
            ),
          ],
        ),
      ),
    );
  }
}