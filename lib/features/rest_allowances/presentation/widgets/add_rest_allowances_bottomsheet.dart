// lib/features/rest_allowances/presentation/widgets/add_rest_allowances_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/blocked_dates_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/shared/widgets/buttons/app_primary_button.dart';
import 'package:leave_manager/shared/widgets/inputs/app_date_range_picker.dart';
import 'package:leave_manager/shared/widgets/inputs/app_dropdown_field.dart';
import 'package:leave_manager/shared/widgets/inputs/app_text_field.dart';
import 'package:leave_manager/shared/widgets/overlays/app_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

void showRestAllowancesBottomSheet(BuildContext context) {
  AppBottomSheet.show(
    context: context,
    title: 'استهلاك رصيد',
    icon: Icons.event_available_rounded,
    iconColor: context.colorScheme.primary,
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
    final blockedDates = context.getBlockedDates();
    DateTime effectiveFirstDate =
        FinancialYearCalculator.currentFinancialYearStart;

    if (_selectedRecord != null &&
        _selectedRecord!.workStartDate.isAfter(effectiveFirstDate)) {
      effectiveFirstDate = _selectedRecord!.workStartDate;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
          builder: (context, state) {
            if (state is RestAllowancesLoaded) {
              final availables = state.extrawork;

              final bool recordExists = availables.any(
                (record) => record == _selectedRecord,
              );
              final ExtraWorkRecord? validSelectedRecord = recordExists
                  ? _selectedRecord
                  : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppDropdownField<ExtraWorkRecord>(
                    value: validSelectedRecord,
                    label: 'اختر الرصيد المراد استهلاكه',
                    prefixIcon: Icons.link_rounded,
                    items: availables.map((record) {
                      final title = record.workReason == WorkReason.holiday
                          ? 'عطلة رسمية'
                          : 'عمل إضافي';
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
                  const SizedBox(height: AppSpacing.md),

                  AppDateRangePicker(
                    startDate: _restStartDate,
                    endDate: _restEndDate,
                    hintText: 'حدد فترة الراحة',
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
                          _restStartDate = pickedRange.start;
                          _restEndDate = pickedRange.end;
                        });
                      }
                    },
                    colorIcon: context.colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: 'ملاحظات (اختياري)',
                    icon: Icons.notes_rounded,
                    controller: _notesController,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  AppPrimaryButton(
                    backgroundColor: context.colorScheme.primary,
                    onPressed: () {
                      if (_selectedRecord == null ||
                          _restStartDate == null ||
                          _restEndDate == null) {
                        AppToast.showError(
                          context,
                          'الرجاء إكمال جميع البيانات.',
                        );
                        return;
                      }

                      final usedDaysCount =
                          _restEndDate!.difference(_restStartDate!).inDays + 1;
                      if (usedDaysCount > _selectedRecord!.daysCount) {
                        AppToast.showError(
                          context,
                          'أيام الراحة المطلوبة تتجاوز الرصيد المتاح.',
                        );
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
                    label:'خصم رصيد',
                    foregroundColor: context.colorScheme.onPrimary,
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
