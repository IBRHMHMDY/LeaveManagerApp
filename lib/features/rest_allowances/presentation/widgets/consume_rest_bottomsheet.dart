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
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

void showConsumeRestBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'استهلاك رصيد بدل راحة',
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
  DateTime? _startDate;
  DateTime? _endDate;
  RestAllowance? _selectedEarnedAllowance;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // ضبط تاريخ البداية الديناميكي بناءً على الرصيد المختار
    DateTime effectiveFirstDate = FinancialYearCalculator.currentFinancialYearStart;
    if (_selectedEarnedAllowance != null && 
        _selectedEarnedAllowance!.startDate.isAfter(effectiveFirstDate)) {
      effectiveFirstDate = _selectedEarnedAllowance!.startDate;
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'حدد النطاق الزمني لاستهلاك أيام من رصيد بدلات الراحة المتاح لديك.',
          style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withAlpha(150)),
        ),
        SizedBox(height: 16.h),
        
        BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
          builder: (context, state) {
            if (state is RestAllowancesLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<RestAllowance>(
                    value: _selectedEarnedAllowance,
                    dropdownColor: colorScheme.surface,
                    decoration: InputDecoration(
                      labelText: 'اختر العمل الإضافي (الرصيد)',
                      prefixIcon: Icon(Icons.link_rounded, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)), 
                    ),
                    items: state.earnedAllowances.map((allowance) {
                      return DropdownMenuItem<RestAllowance>(
                        value: allowance,
                        child: Text(
                        allowance.startDate.isAtSameMomentAs(allowance.endDate) ? 
                        allowance.startDate.toFormatCurrentLocale() : '${allowance.startDate.toFormatCurrentLocale()} - ${allowance.endDate.toFormatCurrentLocale()}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedEarnedAllowance = val;
                        
                        // إعادة تعيين التواريخ لتجنب أخطاء إذا اختار المستخدم رصيداً تاريخه أحدث من التاريخ المحدد مسبقاً
                        if (_startDate != null && val != null && _startDate!.isBefore(val.startDate)) {
                          _startDate = null;
                          _endDate = null;
                        }
                        
                        if (val != null) {
                          if (val.notes != null && val.notes!.isNotEmpty) {
                            _notesController.text = 'بدل عطله (${val.notes}) ';
                          } else {
                            _notesController.text = 'بدل إضافي';
                          }
                        }
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  
                  CustomDateRangePickerField(
                    startDate: _startDate,
                    endDate: _endDate,
                    hintText: 'تاريخ الاستهلاك (الراحة)',
                    firstDate: effectiveFirstDate, // ربط تاريخ التقويم بتاريخ الاكتساب ديناميكياً
                    lastDate: FinancialYearCalculator.currentFinancialYearEnd,
                    onDateSelected: (pickedRange) {
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
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    onPressed: () {
                      if (_selectedEarnedAllowance == null || _startDate == null || _endDate == null) {
                        AppToast.showError(context, 'يرجى إكمال جميع الحقول.');
                        return;
                      }
                      
                      context.read<RestAllowancesBloc>().add(
                        ConsumeRestEvent(
                          startDate: _startDate!,
                          endDate: _endDate!,
                          linkedEarnedDate: _selectedEarnedAllowance!.startDate, 
                          notes: _notesController.text.trim(),
                        ),
                      );
                      context.pop();
                    },
                    child: Text('استهلاك الرصيد', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}