import 'package:flutter/material.dart';

/// امتداد المظهر المخصص لألوان حالات الإجازات
class LeaveColors extends ThemeExtension<LeaveColors> {
  final Color regular;
  final Color casual;
  final Color restAllowance;

  const LeaveColors({
    required this.regular,
    required this.casual,
    required this.restAllowance,
  });

  @override
  ThemeExtension<LeaveColors> copyWith({
    Color? regular,
    Color? casual,
    Color? restAllowance,
  }) {
    return LeaveColors(
      regular: regular ?? this.regular,
      casual: casual ?? this.casual,
      restAllowance: restAllowance ?? this.restAllowance,
    );
  }

  @override
  ThemeExtension<LeaveColors> lerp(
      covariant ThemeExtension<LeaveColors>? other, double t) {
    if (other is! LeaveColors) return this;
    return LeaveColors(
      regular: Color.lerp(regular, other.regular, t)!,
      casual: Color.lerp(casual, other.casual, t)!,
      restAllowance: Color.lerp(restAllowance, other.restAllowance, t)!,
    );
  }
}