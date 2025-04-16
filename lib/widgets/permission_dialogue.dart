// permission_dialogue.dart

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestLocationPermission(BuildContext context) async {
  // Check current status
  final status = await Permission.locationWhenInUse.status;

  // If already granted, return true
  if (status.isGranted || status.isLimited) {
    return true;
  }

  // If permanently denied, show settings dialog
  if (status.isPermanentlyDenied) {
    final shouldOpenSettings =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                'Location permission is permanently denied. '
                'Please enable it in app settings to continue.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Open Settings'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldOpenSettings) {
      await openAppSettings();
    }
    return false;
  }

  // For other cases, request permission (will show native dialog)
  final result = await Permission.locationWhenInUse.request();
  return result.isGranted || result.isLimited;
}
