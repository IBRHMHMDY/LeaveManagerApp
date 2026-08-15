import 'package:flutter/material.dart';

/// امتداد المظهر المخصص لألوان حالات الإجازات
class LeaveColors extends ThemeExtension<LeaveColors> {
  final Color regular;
  final Color casual;
  final Color rest;
  final Color usedRest;

  const LeaveColors({
    required this.regular,
    required this.casual,
    required this.rest,
    required this.usedRest
  });

  @override
  ThemeExtension<LeaveColors> copyWith({
    Color? regular,
    Color? casual,
    Color? rest,
    Color? usedRest
  }) {
    return LeaveColors(
      regular: regular ?? this.regular,
      casual: casual ?? this.casual,
      rest: rest ?? this.rest,
      usedRest: usedRest ?? this.usedRest,
    );
  }

  @override
  ThemeExtension<LeaveColors> lerp(
    covariant ThemeExtension<LeaveColors>? other,
    double t,
  ) {
    if (other is! LeaveColors) return this;
    return LeaveColors(
      regular: Color.lerp(regular, other.regular, t)!,
      casual: Color.lerp(casual, other.casual, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
      usedRest: Color.lerp(usedRest, other.usedRest, t)!,
    );
  }
}
