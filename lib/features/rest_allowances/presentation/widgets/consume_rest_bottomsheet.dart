import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/build_empty_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

void showConsumeRestBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'طلب إجازة راحة',
    icon: Icons.event_available_rounded,
    isScrollControlled: true,
    child: const _ConsumeRestForm(),
  );
}

class _ConsumeRestForm extends StatefulWidget {
  const _ConsumeRestForm();

  @override
  State<_ConsumeRestForm> createState() => _ConsumeRestFormState();
}

class _ConsumeRestFormState extends State<_ConsumeRestForm> {
  DateTime? _selectedConsumedDate;
  RestAllowance? _selectedAllowance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
      builder: (context, state) {
        if (state is RestAllowancesLoaded) {
          final availableAllowances = state.availableAllowances;

          if (availableAllowances.isEmpty) {
            return const BuildEmptyState();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'اختر يوم الراحة المكتسب الذي تود استهلاكه وتاريخ الإجازة المطلوب.',
                style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withAlpha(150)),
              ),
              SizedBox(height: 16.h),
              
              // 1. اختيار بدل الراحة المكتسب المراد استهلاكه (Dropdown)
              DropdownButtonFormField<RestAllowance>(
                value: _selectedAllowance,
                dropdownColor: colorScheme.surface,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary),
                decoration: InputDecoration(
                  labelText: 'تاريخ يوم/ايام العمل الاضافى',
                  prefixIcon: Icon(Icons.workspace_premium_outlined, color: colorScheme.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  ),
                ),
                items: availableAllowances.map((allowance) {
                  return DropdownMenuItem<RestAllowance>(
                    value: allowance,
                    child: Text(
                      allowance.earnedDate.toFormatCurrentLocale(),
                      style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedAllowance = val;
                  });
                },
              ),
              SizedBox(height: 16.h),
              
              // 2. اختيار تاريخ الإجازة المطلوبة
              CustomDateRangePickerField(
                startDate: _selectedConsumedDate,
                endDate: _selectedConsumedDate,
                hintText: 'تاريخ بدل الراحه',
                firstDate: FinancialYearCalculator.currentFinancialYearStart,
                lastDate: FinancialYearCalculator.currentFinancialYearEnd, 
                onDateSelected: (DateTimeRange? pickedRange) {
                  if (pickedRange != null) {
                    setState(() {
                      _selectedConsumedDate = pickedRange.start;
                    });
                  }
                },
              ),
              SizedBox(height: 24.h),
              
              // 3. زر الحفظ
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () {
                  if (_selectedAllowance == null) {
                    AppToast.showError(context, 'يرجى اختيار الراحة المكتسبة.');
                    return;
                  }
                  if (_selectedConsumedDate == null) {
                    AppToast.showError(context, 'يرجى تحديد تاريخ الإجازة.');
                    return;
                  }

                  context.read<RestAllowancesBloc>().add(
                    ConsumeRestEvent(
                      id: _selectedAllowance!.id,
                      consumedDate: _selectedConsumedDate!,
                    ),
                  );
                  
                  context.pop();
                },
                child: Text('إضافه بدل راحه', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          );
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}