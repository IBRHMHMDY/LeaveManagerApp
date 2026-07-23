// lib/features/leaves/presentation/widgets/add_leave_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class AddLeaveForm extends StatefulWidget {
  const AddLeaveForm({super.key});

  @override
  AddLeaveFormState createState() => AddLeaveFormState();
}

class AddLeaveFormState extends State<AddLeaveForm> {
  LeaveType _selectedType = LeaveType.regular;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// دالة للتحقق مما إذا كان اليوم يقع ضمن أي عطلة رسمية أو إجازة مسجلة مسبقاً
  bool _isDaySelectable(
      DateTime day, List<Holiday> holidays, List<LeaveRecord> existingLeaves) {
    final dateToCheck = DateTime(day.year, day.month, day.day);

    // 1. التحقق من العطلات الرسمية
    for (final holiday in holidays) {
      final start = DateTime(
          holiday.startDate.year, holiday.startDate.month, holiday.startDate.day);
      final end = DateTime(
          holiday.endDate.year, holiday.endDate.month, holiday.endDate.day);

      if ((dateToCheck.isAtSameMomentAs(start) || dateToCheck.isAfter(start)) &&
          (dateToCheck.isAtSameMomentAs(end) || dateToCheck.isBefore(end))) {
        return false; // اليوم ضمن عطلة رسمية
      }
    }

    // 2. التحقق من الإجازات المسجلة مسبقاً للموظف
    for (final leave in existingLeaves) {
      final start = DateTime(
          leave.startDate.year, leave.startDate.month, leave.startDate.day);
      final end = DateTime(
          leave.endDate.year, leave.endDate.month, leave.endDate.day);

      if ((dateToCheck.isAtSameMomentAs(start) || dateToCheck.isAfter(start)) &&
          (dateToCheck.isAtSameMomentAs(end) || dateToCheck.isBefore(end))) {
        return false; // اليوم تم تسجيله كإجازة مسبقاً
      }
    }

    return true; // يمكن اختياره
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.black12 : Colors.grey.shade50;

    // جلب العطلات الرسمية
    final holidaysState = context.watch<HolidaysCubit>().state;
    List<Holiday> holidays = [];
    if (holidaysState is HolidaysLoaded) {
      holidays = holidaysState.financialYearHolidays;
    }

    // جلب الإجازات المسجلة مسبقاً
    final leavesState = context.watch<LeavesBloc>().state;
    List<LeaveRecord> existingLeaves = [];
    if (leavesState is LeavesLoaded) {
      existingLeaves = leavesState.currentYearLeaves;
    }

    return BlocListener<LeavesBloc, LeavesState>(
      bloc: context.read<LeavesBloc>(),
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          AppToast.showSuccess(context, 'تمت إضافة الإجازة بنجاح');
          context.pop();
        } 
        // 👇 إضافة الاستماع لحالة الخطأ لعرض التنبيه
        else if (state is LeavesError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<LeaveType>(
            initialValue: _selectedType,
            dropdownColor: colorScheme.surface,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold
            ),
            decoration: InputDecoration(
              labelText: 'نوع الإجازة',
              labelStyle: TextStyle(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: colorScheme.primary,
                size: 24.w,
              ),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: colorScheme.primary, width: 2.w),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: LeaveType.regular,
                child: Text('إعتيادي'),
              ),
              DropdownMenuItem(value: LeaveType.casual, child: Text('عارضة')),
            ],
            onChanged: (val) {
              setState(() {
                _selectedType = val!;
                _startDate = null;
                _endDate = null;
              });
            },
          ),
          SizedBox(height: 16.h),
          
          CustomDateRangePickerField(
            startDate: _startDate,
            endDate: _endDate,
            hintText: 'تاريخ بداية ونهاية الإجازة',
            firstDate: FinancialYearCalculator.currentFinancialYearStart,
            lastDate: DateTime.now(),
            // 👇 تمرير الإجازات المسجلة مع العطلات لمنع المستخدم من اختيارها أصلاً
            selectableDayPredicate: (day) =>
                _isDaySelectable(day, holidays, existingLeaves),
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
          SizedBox(height: 8.h),
          
          BlocBuilder<LeavesBloc, LeavesState>(
            bloc: context.read<LeavesBloc>(),
            builder: (context, state) {
              final isLoading = state is LeavesLoading;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        if (_startDate != null && _endDate != null) {
                          final daysCount =
                              _endDate!.difference(_startDate!).inDays + 1;
                          final record = LeaveRecord(
                            id: 0,
                            leaveType: _selectedType,
                            startDate: _startDate!,
                            endDate: _endDate!,
                            daysCount: daysCount,
                            notes: _notesController.text,
                          );
                          context.read<LeavesBloc>().add(
                            AddNewLeaveEvent(record),
                          );
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'إضافه أجازه',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}