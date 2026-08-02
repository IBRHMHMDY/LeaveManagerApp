// lib/features/rest_allowances/presentation/widgets/add_extra_work_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/core/utils/extenstions/blocked_dates_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

void showAddExtraWorkBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'تسجيل إضافي / عطلة',
    icon: Icons.add_circle_outline_rounded,
    iconColor: context.leaveColors.restAllowance,
    isScrollControlled: true,
    child: const _AddExtraWorkForm(),
  );
}

class _AddExtraWorkForm extends StatefulWidget {
  const _AddExtraWorkForm();

  @override
  State<_AddExtraWorkForm> createState() => _AddExtraWorkFormState();
}

class _AddExtraWorkFormState extends State<_AddExtraWorkForm> {
  DateTime? _startDate;
  DateTime? _endDate;
  WorkReason _selectedReason = WorkReason.holiday;
  Holiday? _selectedHoliday;

  @override
  Widget build(BuildContext context) {
    final blockedDates = context.getBlockedDates(includeHolidays: false);
    final restColor = context.leaveColors.restAllowance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<WorkReason>(
          value: _selectedReason,
          dropdownColor: context.colorScheme.surface,
          decoration: InputDecoration(
            labelText: 'نوع العمل',
            prefixIcon: Icon(Icons.work_history_rounded, color: restColor),
          ),
          items: const [
            DropdownMenuItem(value: WorkReason.holiday, child: Text('عطلة رسمية')),
            DropdownMenuItem(value: WorkReason.overtime, child: Text('عمل إضافي')),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedReason = val;
                _startDate = null;
                _endDate = null;
                _selectedHoliday = null;
              });
            }
          },
        ),
        SizedBox(height: AppSpacing.md),
        
        if (_selectedReason == WorkReason.holiday) ...[
          BlocBuilder<HolidaysCubit, HolidaysState>(
            builder: (context, state) {
              if (state is HolidaysLoaded) {
                final restState = context.read<RestAllowancesBloc>().state;
                List<int> registeredHolidayIds = [];
                
                if (restState is RestAllowancesLoaded) {
                  registeredHolidayIds = restState.extrawork
                      .where((ot) => ot.holidayId != null)
                      .map((ot) => ot.holidayId!)
                      .toList();
                }

                final availableHolidays = state.financialYearHolidays
                    .where((holiday) => !registeredHolidayIds.contains(holiday.id))
                    .toList();

                if (availableHolidays.isEmpty) {
                  return Text(
                    'لا توجد عطلات متاحة', 
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  );
                }

                return DropdownButtonFormField<Holiday>(
                  value: _selectedHoliday,
                  dropdownColor: context.colorScheme.surface,
                  decoration: InputDecoration(
                    labelText: 'اختر العطلة',
                    prefixIcon: Icon(Icons.celebration_rounded, color: restColor),
                  ),
                  items: availableHolidays.map((holiday) {
                    return DropdownMenuItem(value: holiday, child: Text(holiday.name));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedHoliday = val;
                        _startDate = val.startDate;
                        _endDate = val.endDate;
                      });
                    }
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          SizedBox(height: AppSpacing.md),
        ],
        
        CustomDateRangePickerField(
          startDate: _startDate,
          endDate: _endDate,
          hintText: _selectedReason == WorkReason.holiday ? 'تواريخ العطلة' : 'تواريخ العمل الإضافي',
          firstDate: FinancialYearCalculator.currentFinancialYearStart,
          lastDate: FinancialYearCalculator.currentFinancialYearEnd,
          selectableDayPredicate: (day) {
            return !blockedDates.contains(DateTime(day.year, day.month, day.day));
          },
          onDateSelected: (DateTimeRange? pickedRange) {
            if (pickedRange != null) {
              setState(() {
                _startDate = pickedRange.start;
                _endDate = pickedRange.end;
              });
            }
          },
          colorIcon: restColor,
        ),
        SizedBox(height: AppSpacing.md),
        
        BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
          builder: (context, state) {
            final isLoading = state is RestAllowancesLoading;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: restColor,
              ),
              onPressed: isLoading ? null : () {
                if (_selectedReason == WorkReason.holiday && _selectedHoliday == null) {
                  AppToast.showError(context, 'يرجى اختيار العطلة.');
                  return;
                }
                if (_startDate == null || _endDate == null) {
                  AppToast.showError(context, 'يرجى تحديد التواريخ.');
                  return;
                }
                
                final daysCount = _endDate!.difference(_startDate!).inDays + 1;

                context.read<RestAllowancesBloc>().add(
                  AddExtraWorkEvent(
                    workStartDate: _startDate!,
                    workEndDate: _endDate!,
                    daysCount: daysCount,
                    workReason: _selectedReason,
                    holidayId: _selectedReason == WorkReason.holiday ? _selectedHoliday?.id : null,
                  ),
                );
                context.pop();
              },
              child: isLoading
                  ? const SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ اضافى/عطله'),
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}