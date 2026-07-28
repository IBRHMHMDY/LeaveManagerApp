// lib/core/utils/extenstions/blocked_dates_extension.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';

extension BlockedDatesExtension on BuildContext {
  Set<DateTime> getBlockedDates({
    bool includeHolidays = true,
    bool includeLeaves = true,
    bool includeOvertimes = true,
    bool includeRestAllowances = true,
  }) {
    final Set<DateTime> blockedDates = {};

    if (includeLeaves) {
      final leavesState = read<LeavesBloc>().state;
      if (leavesState is LeavesLoaded) {
        for (final leave in leavesState.currentYearLeaves) {
          _addDatesToSet(blockedDates, leave.startDate, leave.endDate);
        }
      }
    }

    if (includeOvertimes || includeRestAllowances) {
      final restState = read<RestAllowancesBloc>().state;
      if (restState is RestAllowancesLoaded) {
        if (includeOvertimes) {
          // 👈 القراءة من القائمة الجديدة extrawork
          for (final overtime in restState.extrawork) { 
            _addDatesToSet(blockedDates, overtime.workStartDate, overtime.workEndDate);
          }
        }
        if (includeRestAllowances) {
          // 👈 القراءة من القائمة الجديدة rest
          for (final rest in restState.rest) {
            if (rest.restStartDate != null && rest.restEndDate != null) {
              _addDatesToSet(blockedDates, rest.restStartDate!, rest.restEndDate!);
            }
          }
        }
      }
    }

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

  void _addDatesToSet(Set<DateTime> set, DateTime start, DateTime end) {
    for (DateTime d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      set.add(DateTime(d.year, d.month, d.day)); 
    }
  }
}