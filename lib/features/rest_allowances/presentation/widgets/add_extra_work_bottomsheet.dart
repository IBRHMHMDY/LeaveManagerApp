// lib/features/rest_allowances/presentation/widgets/add_extra_work_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/core/utils/extenstions/blocked_dates_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

void showAddExtraWorkBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'إضافة عمل إضافي / عطلة',
    icon: Icons.add_circle_outline_rounded,
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
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final blockedDates = context.getBlockedDates(includeHolidays: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<WorkReason>(
          value: _selectedReason,
          dropdownColor: colorScheme.surface,
          decoration: InputDecoration(
            labelText: 'نوع العمل',
            prefixIcon: Icon(Icons.work_history_rounded, color: colorScheme.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          items: const [
            DropdownMenuItem(value: WorkReason.holiday, child: Text('عطلة رسمية')),
            DropdownMenuItem(value: WorkReason.overtime, child: Text('عمل إضافي (Overtime)')),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedReason = val;
                _startDate = null;
                _endDate = null;
                _selectedHoliday = null;
                _notesController.clear();
              });
            }
          },
        ),
        SizedBox(height: 16.h),
        
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
                  return Text('لا توجد عطلات متاحة للتسجيل.', style: TextStyle(color: colorScheme.error));
                }

                return DropdownButtonFormField<Holiday>(
                  value: _selectedHoliday,
                  dropdownColor: colorScheme.surface,
                  decoration: InputDecoration(
                    labelText: 'اختر العطلة',
                    prefixIcon: Icon(Icons.celebration_rounded, color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
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
                        _notesController.text = 'عطلة: ${val.name}';
                      });
                    }
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          SizedBox(height: 16.h),
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
        ),
        SizedBox(height: 16.h),
        
        CustomTextField(
          label: 'ملاحظات (اختياري)',
          icon: Icons.notes_rounded,
          controller: _notesController,
        ),
        SizedBox(height: 24.h),
        
        BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
          builder: (context, state) {
            final isLoading = state is RestAllowancesLoading;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
                    notes: _notesController.text.trim(),
                    holidayId: _selectedReason == WorkReason.holiday ? _selectedHoliday?.id : null,
                  ),
                );
                context.pop();
              },
              child: isLoading
                  ? SizedBox(height: 24.h, width: 24.h, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2))
                  : Text('حفظ', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}