import 'package:flutter/material.dart';

class StepData {
  final String title;
  final Widget content;
  final GlobalKey<FormState> formKey;
  final IconData? icon;

  StepData({
    required this.title,
    required this.content,
    required this.formKey,
    this.icon,
  });
}
