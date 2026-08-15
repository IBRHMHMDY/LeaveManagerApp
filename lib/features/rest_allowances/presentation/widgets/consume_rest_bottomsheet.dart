// lib/features/rest_allowances/presentation/widgets/consume_rest_bottomsheet.dart
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
import 'package:leave_manager/shared/widgets/buttons/app_primary_button.dart';
import 'package:leave_manager/shared/widgets/inputs/app_date_range_picker.dart';
import 'package:leave_manager/shared/widgets/inputs/app_text_field.dart';
import 'package:leave_manager/shared/widgets/overlays/app_bottom_sheet.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

void showConsumeRestBottomSheet(BuildContext context, ExtraWorkRecord record) {
  AppBottomSheet.show(
    context: context,
    title: 'استهلاك بدل راحة',
    icon: Icons.event_available_rounded,
    iconColor: context.colorScheme.primary,
    isScrollControlled: true,
    child: _ConsumeRestForm(record: record),
  );
}

class _ConsumeRestForm extends StatefulWidget {
  final ExtraWorkRecord record;
  const _ConsumeRestForm({required this.record});

  @override
  State<_ConsumeRestForm> createState() => _ConsumeRestFormState();
}

class _ConsumeRestFormState extends State<_ConsumeRestForm> {
  DateTime? _restStartDate;
  DateTime? _restEndDate;
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

    // منع اختيار تاريخ استهلاك يسبق تاريخ العمل الإضافي
    if (widget.record.workStartDate.isAfter(effectiveFirstDate)) {
      effectiveFirstDate = widget.record.workStartDate;
    }

    final title = widget.record.workReason == WorkReason.holiday
        ? 'عطلة رسمية'
        : 'عمل إضافي';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDateRangePicker(
          startDate: _restStartDate,
          endDate: _restEndDate,
          hintText: 'تاريخ استهلاك الراحة',
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
        // بطاقة توضيحية للرصيد المحدد
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'بدل راحه عن: $title (${widget.record.daysCount} أيام)',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
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
            if (_restStartDate == null || _restEndDate == null) {
              AppToast.showError(context, 'يرجى تحديد تاريخ الاستهلاك.');
              return;
            }
            final usedDaysCount =
                _restEndDate!.difference(_restStartDate!).inDays + 1;

            if (usedDaysCount > widget.record.daysCount) {
              AppToast.showError(
                context,
                'عدد الأيام المحددة يتجاوز الرصيد المتاح (${widget.record.daysCount} أيام).',
              );
              return;
            }

            context.read<RestAllowancesBloc>().add(
              ConsumeRestEvent(
                allowanceId: widget.record.id,
                restStartDate: _restStartDate!,
                restEndDate: _restEndDate!,
                usedDaysCount: usedDaysCount,
                notes: _notesController.text.trim(),
              ),
            );
            context.pop();
          },
          label: 'خصم رصيد',
          foregroundColor: context.colorScheme.onPrimary,
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}
