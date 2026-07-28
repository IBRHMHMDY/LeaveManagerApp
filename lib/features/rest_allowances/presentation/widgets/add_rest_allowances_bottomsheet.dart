// lib/features/rest_allowances/presentation/widgets/add_rest_allowances_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/blocked_dates_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
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
    title: 'استهلاك بدل راحة',
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
  DateTime? _restStartDate;
  DateTime? _restEndDate;
  ExtraWorkRecord? _selectedRecord;
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

    DateTime effectiveFirstDate = FinancialYearCalculator.currentFinancialYearStart;
    if (_selectedRecord != null && _selectedRecord!.workStartDate.isAfter(effectiveFirstDate)) {
      effectiveFirstDate = _selectedRecord!.workStartDate;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
          builder: (context, state) {
            if (state is RestAllowancesLoaded) {
              final availables = state.extrawork; // الأرصدة المتاحة للتقسيم/الاستهلاك
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<ExtraWorkRecord>(
                    value: _selectedRecord,
                    dropdownColor: colorScheme.surface,
                    decoration: InputDecoration(
                      labelText: 'اختر الرصيد المتاح',
                      prefixIcon: Icon(Icons.link_rounded, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    items: availables.map((record) {
                      final title = record.workReason == WorkReason.holiday ? 'عطلة' : 'عمل إضافي';
                      return DropdownMenuItem<ExtraWorkRecord>(
                        value: record,
                        child: Text('$title (${record.daysCount} أيام)'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedRecord = val;
                        _restStartDate = null;
                        _restEndDate = null;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  
                  CustomDateRangePickerField(
                    startDate: _restStartDate,
                    endDate: _restEndDate,
                    hintText: 'تواريخ الراحة المطلوبة',
                    firstDate: effectiveFirstDate,
                    lastDate: FinancialYearCalculator.currentFinancialYearEnd,
                    selectableDayPredicate: (day) {
                      return !blockedDates.contains(DateTime(day.year, day.month, day.day));
                    },
                    onDateSelected: (pickedRange) {
                      if (pickedRange != null) {
                        setState(() {
                          _restStartDate = pickedRange.start;
                          _restEndDate = pickedRange.end;
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    onPressed: () {
                      if (_selectedRecord == null || _restStartDate == null || _restEndDate == null) {
                        AppToast.showError(context, 'يرجى إكمال جميع الحقول.');
                        return;
                      }

                      final usedDaysCount = _restEndDate!.difference(_restStartDate!).inDays + 1;

                      if (usedDaysCount > _selectedRecord!.daysCount) {
                        AppToast.showError(context, 'أيام الراحة المطلوبة تتجاوز رصيد السجل المختار.');
                        return;
                      }

                      context.read<RestAllowancesBloc>().add(
                        ConsumeRestEvent(
                          allowanceId: _selectedRecord!.id,
                          restStartDate: _restStartDate!,
                          restEndDate: _restEndDate!,
                          usedDaysCount: usedDaysCount,
                          notes: _notesController.text.trim(),
                        ),
                      );
                      context.pop();
                    },
                    child: Text(
                      'تأكيد استهلاك الراحة',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
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