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
import 'package:leave_manager/shared/widgets/buttons/app_primary_button.dart';
import 'package:leave_manager/shared/widgets/inputs/app_date_range_picker.dart';
import 'package:leave_manager/shared/widgets/inputs/app_dropdown_field.dart';
import 'package:leave_manager/shared/widgets/overlays/app_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

void showAddExtraWorkBottomSheet(
  BuildContext context, {
  Holiday? initialHoliday,
}) {
  AppBottomSheet.show(
    context: context,
    title: 'إضافه رصيد',
    icon: Icons.add_circle_outline_rounded,
    iconColor: context.colorScheme.primary,
    isScrollControlled: true,
    child: _AddExtraWorkForm(initialHoliday: initialHoliday),
  );
}

class _AddExtraWorkForm extends StatefulWidget {
  final Holiday? initialHoliday;
  const _AddExtraWorkForm({this.initialHoliday});

  @override
  State<_AddExtraWorkForm> createState() => _AddExtraWorkFormState();
}

class _AddExtraWorkFormState extends State<_AddExtraWorkForm> {

  DateTime? _startDate;
  DateTime? _endDate;
  late WorkReason _selectedReason;
  Holiday? _selectedHoliday;

  @override
  void initState() {
    super.initState();
    // تهيئة البيانات تلقائياً إذا تم تمرير عطلة من شاشة أخرى
    if (widget.initialHoliday != null) {
      _selectedReason = WorkReason.holiday;
      _selectedHoliday = widget.initialHoliday;
      _startDate = widget.initialHoliday!.startDate;
      _endDate = widget.initialHoliday!.endDate;
    } else {
      _selectedReason = WorkReason.holiday;
    }
  }

  @override
  Widget build(BuildContext context) {
    final blockedDates = context.getBlockedDates(includeHolidays: false);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDropdownField<WorkReason>(
            value: _selectedReason,
            label: 'نوع العمل',
            prefixIcon: Icons.work_history_rounded,
            items: const [
              DropdownMenuItem(
                value: WorkReason.holiday,
                child: Text('عطلة رسمية'),
              ),
              DropdownMenuItem(
                value: WorkReason.overtime,
                child: Text('عمل إضافي'),
              ),
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
          const SizedBox(height: AppSpacing.md),
      
          if (_selectedReason == WorkReason.holiday) ...[
            BlocBuilder<HolidaysCubit, HolidaysState>(
              builder: (context, state) {
                if (state is HolidaysLoaded) {
                  final restState = context.read<RestAllowancesBloc>().state;
                  List<int> registeredHolidayIds = [];
      
                  if (restState is RestAllowancesLoaded) {
                    // التعديل هنا: دمج السجلات المتاحة والمستهلكة في قائمة واحدة
                    final allRecords = [
                      ...restState.extrawork,
                      ...restState.rest,
                    ];
      
                    registeredHolidayIds = allRecords
                        .where((record) => record.holidayId != null)
                        .map((record) => record.holidayId!)
                        .toList();
                  }
      
                  final availableHolidays = state.financialYearHolidays
                      .where(
                        (holiday) => !registeredHolidayIds.contains(holiday.id),
                      )
                      .toList();
                  // إضافة العطلة الممررة إلى القائمة إذا لم تكن موجودة لمنع أخطاء الـ Dropdown
                  if (_selectedHoliday != null &&
                      !availableHolidays.any(
                        (h) => h.id == _selectedHoliday!.id,
                      )) {
                    availableHolidays.add(_selectedHoliday!);
                  }
                  if (availableHolidays.isEmpty) {
                    return Text(
                      'لا توجد عطلات متاحة',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.error,
                      ),
                    );
                  }
      
                  return AppDropdownField<Holiday>(
                    value: _selectedHoliday,
                    label: 'اختر العطلة',
                    prefixIcon: Icons.celebration_rounded,
                    items: availableHolidays.map((holiday) {
                      return DropdownMenuItem(
                        value: holiday,
                        child: Text(holiday.name),
                      );
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
            const SizedBox(height: AppSpacing.md),
          ],
      
          AppDateRangePicker(
            startDate: _startDate,
            endDate: _endDate,
            hintText: _selectedReason == WorkReason.holiday
                ? 'تواريخ العطلة'
                : 'تواريخ العمل الإضافي',
            firstDate: FinancialYearCalculator.currentFinancialYearStart,
            lastDate: FinancialYearCalculator.currentFinancialYearEnd,
            selectableDayPredicate: (day) {
              return !blockedDates.contains(
                DateTime(day.year, day.month, day.day),
              );
            },
            onDateSelected: (DateTimeRange? pickedRange) {
              if (pickedRange != null) {
                setState(() {
                  _startDate = pickedRange.start;
                  _endDate = pickedRange.end;
                });
              }
            },
            colorIcon: context.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
      
          BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
            builder: (context, state) {
              final isLoading = state is RestAllowancesLoading;
              return AppPrimaryButton(
                label: 'اضافه رصيد',
                backgroundColor: context.colorScheme.primary,
                onPressed: isLoading
                    ? null
                    : () {
                        if (_selectedReason == WorkReason.holiday &&
                            _selectedHoliday == null) {
                          AppToast.showError(context, 'يرجى اختيار العطلة.');
                          return;
                        }
                        if (_startDate == null || _endDate == null) {
                          AppToast.showError(context, 'يرجى تحديد التواريخ.');
                          return;
                        }
      
                        final daysCount =
                            _endDate!.difference(_startDate!).inDays + 1;
      
                        context.read<RestAllowancesBloc>().add(
                          AddExtraWorkEvent(
                            workStartDate: _startDate!,
                            workEndDate: _endDate!,
                            daysCount: daysCount,
                            workReason: _selectedReason,
                            holidayId: _selectedReason == WorkReason.holiday
                                ? _selectedHoliday?.id
                                : null,
                          ),
                        );
                        context.pop();
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
