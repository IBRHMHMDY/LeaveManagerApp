// lib/core/utils/extenstions/blocked_dates_extension.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';

/// Extension on BuildContext to extract globally blocked dates
/// across Leaves, Holidays, and Rest Allowances.
extension BlockedDatesExtension on BuildContext {
  /// يولد مجموعة من التواريخ المحجوزة بناءً على المعطيات المطلوبة
  Set<DateTime> getBlockedDates({
    bool includeHolidays = true,
    bool includeLeaves = true,
    bool includeOvertimes = true,
    bool includeRestAllowances = true,
  }) {
    final Set<DateTime> blockedDates = {};

    // 1. تضمين تواريخ الإجازات
    if (includeLeaves) {
      final leavesState = read<LeavesBloc>().state;
      if (leavesState is LeavesLoaded) {
        for (final leave in leavesState.currentYearLeaves) {
          _addDatesToSet(blockedDates, leave.startDate, leave.endDate);
        }
      }
    }

    // 2. تضمين تواريخ العمل الإضافي وبدلات الراحة المستهلكة
    if (includeOvertimes || includeRestAllowances) {
      final restState = read<RestAllowancesBloc>().state;
      if (restState is RestAllowancesLoaded) {
        if (includeOvertimes) {
          for (final overtime in restState.earnedAllowances) {
            _addDatesToSet(blockedDates, overtime.startDate, overtime.endDate);
          }
        }
        if (includeRestAllowances) {
          for (final rest in restState.consumedAllowances) {
            _addDatesToSet(blockedDates, rest.startDate, rest.endDate);
          }
        }
      }
    }

    // 3. تضمين تواريخ العطلات الرسمية
    if (includeHolidays) {
      final holidaysState = read<HolidaysCubit>().state;
      if (holidaysState is HolidaysLoaded) {
        for (final holiday in holidaysState.financialYearHolidays) {
          _addDatesToSet(blockedDates, holiday.startDate, holiday.endDate);
        }
      }
    }

    return blockedDates;
  }

  /// دالة مساعدة لتوليد الأيام بين تاريخين وإضافتها إلى المجموعة
  void _addDatesToSet(Set<DateTime> set, DateTime start, DateTime end) {
    for (DateTime d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      // إزالة أي فوارق زمنية (الساعات/الدقائق) لضمان دقة المقارنة
      set.add(DateTime(d.year, d.month, d.day)); 
    }
  }
}