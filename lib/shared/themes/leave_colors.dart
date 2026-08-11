import 'package:flutter/material.dart';

/// امتداد المظهر المخصص لألوان حالات الإجازات
class LeaveColors extends ThemeExtension<LeaveColors> {
  final Color regular;
  final Color casual;
  final Color rest;

  const LeaveColors({
    required this.regular,
    required this.casual,
    required this.rest,
  });

  @override
  ThemeExtension<LeaveColors> copyWith({
    Color? regular,
    Color? casual,
    Color? rest,
  }) {
    return LeaveColors(
      regular: regular ?? this.regular,
      casual: casual ?? this.casual,
      rest: rest ?? this.rest,
    );
  }

  @override
  ThemeExtension<LeaveColors> lerp(
      covariant ThemeExtension<LeaveColors>? other, double t) {
    if (other is! LeaveColors) return this;
    return LeaveColors(
      regular: Color.lerp(regular, other.regular, t)!,
      casual: Color.lerp(casual, other.casual, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
    );
  }
}