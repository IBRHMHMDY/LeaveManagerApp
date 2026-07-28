// lib/features/rest_allowances/presentation/widgets/consume_rest_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/blocked_dates_extension.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

void showRestAllowancesBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    context: context,
    title: 'تسجيل بدل راحة',
    icon: Icons.event_available_rounded,
    isScrollControlled: true,
    child: const _AddRestAllowancesForm(),
  );
}

class _AddRestAllowancesForm extends StatefulWidget {
  const _AddRestAllowancesForm();

  @override
  State<_AddRestAllowancesForm> createState() => _AddRestAllowancesFormState();
}

class _AddRestAllowancesFormState extends State<_AddRestAllowancesForm> {
  DateTime? _startDate;
  DateTime? _endDate;
  OvertimeRecord? _selectedOvertime;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final blockedDates = context.getBlockedDates();
    DateTime effectiveFirstDate =
        FinancialYearCalculator.currentFinancialYearStart;
    if (_selectedOvertime != null &&
        _selectedOvertime!.startDate.isAfter(effectiveFirstDate)) {
      effectiveFirstDate = _selectedOvertime!.startDate;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'اختر يوم العمل الإضافي المتاح لخصم بدل الراحة منه.',
          style: TextStyle(
            fontSize: 14.sp,
            color: colorScheme.onSurface.withAlpha(150),
          ),
        ),
        SizedBox(height: 16.h),

        BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
          builder: (context, state) {
            if (state is RestAllowancesLoaded) {
              // تصفية الأرصدة المتاحة التي لم يتم استهلاكها بعد
              final availableOvertimes = state.earnedAllowances
                  .where((ot) => !ot.isConsumed)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<OvertimeRecord>(
                    value: _selectedOvertime,
                    dropdownColor: colorScheme.surface,
                    decoration: InputDecoration(
                      labelText: 'اختر الرصيد الأساسي',
                      prefixIcon: Icon(
                        Icons.link_rounded,
                        color: colorScheme.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: availableOvertimes.map((ot) {
                      final title = ot.workReason == WorkReason.holiday
                          ? 'عن عطلة'
                          : 'عن إضافي';
                      final date = ot.startDate.isAtSameMomentAs(ot.endDate)
                          ? ot.startDate.toFormatCurrentLocale()
                          : '${ot.startDate.toFormatCurrentLocale()} - ${ot.endDate.toFormatCurrentLocale()}';
                      return DropdownMenuItem<OvertimeRecord>(
                        value: ot,
                        child: Text('$title ($date)'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedOvertime = val;

                        if (_startDate != null &&
                            val != null &&
                            _startDate!.isBefore(val.startDate)) {
                          _startDate = null;
                          _endDate = null;
                        }

                        if (val != null) {
                          final reasonLabel =
                              val.workReason == WorkReason.holiday
                              ? 'عطلة رسمية'
                              : 'يوم عمل إضافي';
                          _notesController.text = 'بدل راحة عن $reasonLabel';
                        }
                      });
                    },
                  ),
                  SizedBox(height: 16.h),

                  CustomDateRangePickerField(
                    startDate: _startDate,
                    endDate: _endDate,
                    hintText: 'تاريخ بدل الراحة',
                    firstDate: effectiveFirstDate,
                    lastDate: FinancialYearCalculator.currentFinancialYearEnd,
                    selectableDayPredicate: (day) {
                      return !blockedDates.contains(
                        DateTime(day.year, day.month, day.day),
                      );
                    },
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
                    label: 'ملاحظات',
                    icon: Icons.notes_rounded,
                    controller: _notesController,
                  ),
                  SizedBox(height: 24.h),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      if (_selectedOvertime == null ||
                          _startDate == null ||
                          _endDate == null) {
                        AppToast.showError(
                          context,
                          'يرجى إكمال الحقول المطلوبة.',
                        );
                        return;
                      }

                      context.read<RestAllowancesBloc>().add(
                        ConsumeRestEvent(
                          startDate: _startDate!,
                          endDate: _endDate!,
                          overtimeId: _selectedOvertime!.id,
                          linkedOvertimeStartDate: _selectedOvertime!.startDate,
                          workReason: _selectedOvertime!.workReason,
                          notes: _notesController.text.trim(),
                        ),
                      );
                      context.pop();
                    },
                    child: Text(
                      'حفظ بدل الراحة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}
