// lib/widgets/permission_request_dialog.dart

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// List all permissions your app may request.
enum AppPermission {
  camera,
  microphone,
  location,
  photos,
  storage,
  notifications,
  contacts,
}

/// Maps your enum to the permission_handler Permission.
Permission _mapEnumToPermission(AppPermission p) {
  switch (p) {
    case AppPermission.camera:
      return Permission.camera;
    case AppPermission.microphone:
      return Permission.microphone



      ;
    case AppPermission.location:
      return Permission.locationWhenInUse;
    case AppPermission.photos:
      return Permission.photos;
    case AppPermission.storage:
      return Permission.storage;
    case AppPermission.notifications:
      return Permission.notification;
    case AppPermission.contacts:
      return Permission.contacts;
  }
}

/// Human‐readable names for dialog titles/content.
String _permissionName(AppPermission p) {
  switch (p) {
    case AppPermission.camera:
      return 'Camera';
    case AppPermission.microphone:
      return 'Microphone';
    case AppPermission.location:
      return 'Location';
    case AppPermission.photos:
      return 'Photos';
    case AppPermission.storage:
      return 'Storage';
    case AppPermission.notifications:
      return 'Notifications';
    case AppPermission.contacts:
      return 'Contacts';
  }
}

/// A reusable permission‐request dialog.
///
/// Pass in the desired [AppPermission], and it will:
/// 1. Show an AlertDialog explaining why you need it.
/// 2. Request it when the user taps “Allow”.
/// 3. Print (and return) the resulting PermissionStatus.
class PermissionRequestDialog extends StatelessWidget {
  final AppPermission permission;

  const PermissionRequestDialog({
    super.key,
    required this.permission,
  });

  Future<PermissionStatus> _requestPermission() async {
    return await _mapEnumToPermission(permission).request();
  }

  @override
  Widget build(BuildContext context) {
    final name = _permissionName(permission);
    return AlertDialog(
      title: Text('$name Permission'),
      content: Text('This app needs access to your $name.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<PermissionStatus?>(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final status = await _requestPermission();
            print('Permission $name status: $status');
            Navigator.of(context).pop<PermissionStatus?>(status);
          },
          child: const Text('Allow'),
        ),
      ],
    );
  }
}

/// Helper function to show the dialog and await the result.
Future<PermissionStatus?> showPermissionDialog(
    BuildContext context,
    AppPermission permission,
    ) {
  return showDialog<PermissionStatus>(
    context: context,
    builder: (_) => PermissionRequestDialog(permission: permission),
  );
}
