import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
// [إضافة] استيراد كيان وحالة العطلات للبحث فيها
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

void showAddEarnedRestBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'إضافة عمل إضافي',
    icon: Icons.add_circle_outline_rounded,
    isScrollControlled: true,
    child: const _AddEarnedRestForm(),
  );
}

class _AddEarnedRestForm extends StatefulWidget {
  const _AddEarnedRestForm();

  @override
  State<_AddEarnedRestForm> createState() => _AddEarnedRestFormState();
}

class _AddEarnedRestFormState extends State<_AddEarnedRestForm> {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'قم بتحديد النطاق الزمني للعمل الإضافي (أيام الراحة المكتسبة).',
          style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withAlpha(150)),
        ),
        SizedBox(height: 16.h),
        
        CustomDateRangePickerField(
          startDate: _startDate,
          endDate: _endDate,
          hintText: 'تاريخ العمل الإضافي',
          firstDate: FinancialYearCalculator.currentFinancialYearStart,
          lastDate: FinancialYearCalculator.currentFinancialYearEnd,
          onDateSelected: (DateTimeRange? pickedRange) {
            if (pickedRange != null) {
              setState(() {
                _startDate = pickedRange.start;
                _endDate = pickedRange.end;

                // [تعديل 1]: تعبئة الملاحظات تلقائياً إذا كان اليوم يوافق عطلة رسمية
                final holidaysState = context.read<HolidaysCubit>().state;
                if (holidaysState is HolidaysLoaded) {
                  final startOnly = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
                  bool isHoliday = false;

                  for (var holiday in holidaysState.financialYearHolidays) {
                    final hStart = DateTime(holiday.startDate.year, holiday.startDate.month, holiday.startDate.day);
                    final hEnd = DateTime(holiday.endDate.year, holiday.endDate.month, holiday.endDate.day);
                    
                    if (!startOnly.isBefore(hStart) && !startOnly.isAfter(hEnd)) {
                      _notesController.text = holiday.name; // كتابة اسم العطلة (مثل: ثورة 23 يوليو)
                      isHoliday = true;
                      break;
                    }
                  }
                  
                  if (!isHoliday) {
                    _notesController.clear();
                  }
                }
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
              onPressed: isLoading
                  ? null
                  : () {
                      if (_startDate == null || _endDate == null) {
                        AppToast.showError(context, 'يرجى تحديد التواريخ أولاً.');
                        return;
                      }
                      
                      context.read<RestAllowancesBloc>().add(
                        AddEarnedRestEvent(
                          startDate: _startDate!,
                          endDate: _endDate!,
                          notes: _notesController.text.trim(),
                        ),
                      );
                      
                      context.pop();
                    },
              child: isLoading
                  ? SizedBox(
                      height: 24.h,
                      width: 24.h,
                      child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2),
                    )
                  : Text('حفظ الرصيد', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}