import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ثوابت المسافات والهوامش المتجاوبة
class AppSpacing {
  static final double xs = 4.w;
  static final double sm = 8.w;
  static final double md = 16.w;
  static final double lg = 24.w;
  static final double xl = 32.w;
  static final double xxl = 48.w;
}

/// ثوابت انحناء الحواف (Border Radius) المتجاوبة
class AppRadii {
  static final BorderRadius xs = BorderRadius.circular(4.r);
  static final BorderRadius sm = BorderRadius.circular(8.r);
  static final BorderRadius md = BorderRadius.circular(12.r);
  static final BorderRadius lg = BorderRadius.circular(16.r);
  static final BorderRadius xl = BorderRadius.circular(24.r);
}