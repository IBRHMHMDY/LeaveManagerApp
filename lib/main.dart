// lib/main.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/leave_manager_app.dart';

void main() async {
  await AppBootstrapper.init();
  runApp(const LeaveManagerApp());
}
