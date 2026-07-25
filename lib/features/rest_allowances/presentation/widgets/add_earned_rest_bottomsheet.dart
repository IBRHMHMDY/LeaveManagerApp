import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

void showAddEarnedRestBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'كسب راحة',
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
  DateTime? _selectedDate;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    // [قاعدة AMD 2026]: تنظيف الذاكرة (Memory Leak Prevention)
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
        // ملاحظة توضيحية للمستخدم
        Text(
          'اختر تاريخ يوم العمل الإضافي أو العطلة التي عملت بها لكسب يوم راحة.',
          style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withAlpha(150)),
        ),
        SizedBox(height: 16.h),
        
        // حقل اختيار التاريخ (نستخدم Range picker لكن نجبره على يوم واحد بتحديد Start = End)
        CustomDateRangePickerField(
          startDate: _selectedDate,
          endDate: _selectedDate, // نمرر نفس التاريخ لاختيار يوم واحد
          hintText: 'تاريخ العمل الإضافي',
          firstDate: FinancialYearCalculator.currentFinancialYearStart,
          lastDate: DateTime.now(), // لا يمكن كسب راحة في المستقبل
          onDateSelected: (DateTimeRange? pickedRange) {
            if (pickedRange != null) {
              setState(() {
                // نأخذ الـ start فقط لأننا نحتاج يوماً واحداً
                _selectedDate = pickedRange.start;
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
        SizedBox(height: 24.h),
        
        // زر الحفظ المرتبط بحالة الـ BLoC
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
                      if (_selectedDate == null) {
                        AppToast.showError(context, 'يرجى اختيار تاريخ العمل الإضافي.');
                        return;
                      }
                      
                      context.read<RestAllowancesBloc>().add(
                        AddEarnedRestEvent(
                          earnedDate: _selectedDate!,
                          notes: _notesController.text.trim(),
                        ),
                      );
                      
                      // إغلاق الـ BottomSheet بعد الإضافة
                      context.pop();
                    },
              child: isLoading
                  ? SizedBox(
                      height: 24.h,
                      width: 24.h,
                      child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2),
                    )
                  : Text('حفظ يوم عمل اضافى', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}