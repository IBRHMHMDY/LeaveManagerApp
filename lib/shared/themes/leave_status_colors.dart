import 'package:flutter/material.dart';

/// امتداد المظهر المخصص لألوان حالات الإجازات
class LeaveStatusColors extends ThemeExtension<LeaveStatusColors> {
  final Color regular;
  final Color casual;
  final Color restAllowance;

  const LeaveStatusColors({
    required this.regular,
    required this.casual,
    required this.restAllowance,
  });

  @override
  ThemeExtension<LeaveStatusColors> copyWith({
    Color? regular,
    Color? casual,
    Color? restAllowance,
  }) {
    return LeaveStatusColors(
      regular: regular ?? this.regular,
      casual: casual ?? this.casual,
      restAllowance: restAllowance ?? this.restAllowance,
    );
  }

  @override
  ThemeExtension<LeaveStatusColors> lerp(
      covariant ThemeExtension<LeaveStatusColors>? other, double t) {
    if (other is! LeaveStatusColors) return this;
    return LeaveStatusColors(
      regular: Color.lerp(regular, other.regular, t)!,
      casual: Color.lerp(casual, other.casual, t)!,
      restAllowance: Color.lerp(restAllowance, other.restAllowance, t)!,
    );
  }
}