// lib/features/leaves/presentation/widgets/add_leave_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 1. استيراد ScreenUtil
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.black12 : Colors.grey.shade50;

    return BlocListener<LeavesBloc, LeavesState>(
      bloc: context.read<LeavesBloc>(),
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          AppToast.showSuccess(context, 'تم اضافه يوم اجازه وخصمه من رصيدك');
          context.pop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // حقل نوع الإجازة
          DropdownButtonFormField<LeaveType>(
            initialValue: _selectedType,
            dropdownColor: colorScheme.surface,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16.sp, // متجاوب
              fontFamily: 'Cairo',
            ),
            decoration: InputDecoration(
              labelText: 'نوع الإجازة',
              labelStyle: TextStyle(
                color: colorScheme.onSurface.withAlpha(150),
              ),
              prefixIcon: Icon(
                Icons.category_rounded,
                color: colorScheme.primary,
                size: 24.w, // متجاوب
              ),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r), // متجاوب
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r), // متجاوب
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r), // متجاوب
                borderSide: BorderSide(color: colorScheme.primary, width: 2.w),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w, // متجاوب (إزالة const)
                vertical: 16.h, // متجاوب
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: LeaveType.regular,
                child: Text('اعتيادية'),
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
          SizedBox(height: 16.h), // متجاوب (إزالة const)

          // استخدام المكون المستقل الجديد لاختيار التاريخ
          CustomDateRangePickerField(
            startDate: _startDate,
            endDate: _endDate,
            hintText: 'اضغط لاختيار فترة الإجازة',
            firstDate: FinancialYearCalculator.currentFinancialYearStart,
            lastDate: DateTime.now(),
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

          // حقل الملاحظات
          CustomTextField(
            label: 'ملاحظات (اختياري)',
            icon: Icons.notes_rounded,
            controller: _notesController,
          ),
          SizedBox(height: 8.h),

          // زر الحفظ
          BlocBuilder<LeavesBloc, LeavesState>(
            bloc: context.read<LeavesBloc>(),
            builder: (context, state) {
              final isLoading = state is LeavesLoading;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16.h), // متجاوب (إزالة const)
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r), // متجاوب
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
                        height: 24.h, // متجاوب
                        width: 24.w,  // متجاوب
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'حفظ الإجازة',
                        style: TextStyle(
                          fontSize: 16.sp, // متجاوب
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