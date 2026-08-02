// lib/features/leaves/presentation/widgets/add_leave_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/blocked_dates_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/shared/widgets/custom_date_range_picker_field.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
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
    final blockedDates = context.getBlockedDates();

    return BlocListener<LeavesBloc, LeavesState>(
      bloc: context.read<LeavesBloc>(),
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          AppToast.showSuccess(context, 'تمت إضافة الإجازة بنجاح');
          context.pop();
        } else if (state is LeavesError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<LeaveType>(
            initialValue: _selectedType,
            dropdownColor: context.colorScheme.surface,
            // التنسيقات موروثة من AppTheme بالكامل
            decoration: const InputDecoration(
              labelText: 'نوع الإجازة',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            items: const [
              DropdownMenuItem(
                value: LeaveType.regular,
                child: Text('إجازة اعتيادية')
              ),
              DropdownMenuItem(
                value: LeaveType.casual, 
                child: Text('إجازة عارضة')
              ),
            ],
            onChanged: (val) {
              setState(() {
                _selectedType = val!;
                _startDate = null;
                _endDate = null;
              });
            },
          ),
          SizedBox(height: AppSpacing.md),
          CustomDateRangePickerField(
            startDate: _startDate,
            endDate: _endDate,
            hintText: 'حدد تاريخ البداية والنهاية',
            firstDate: FinancialYearCalculator.currentFinancialYearStart,
            lastDate: DateTime(DateTime.now().year + 10),
            selectableDayPredicate: (day) {
              final dateToCheck = DateTime(day.year, day.month, day.day);
              return !blockedDates.contains(dateToCheck);
            },
            onDateSelected: (DateTimeRange? pickedRange) {
              if (pickedRange != null) {
                setState(() {
                  _startDate = pickedRange.start;
                  _endDate = pickedRange.end;
                });
              }
            },
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: 'ملاحظات (اختياري)',
            icon: Icons.notes_rounded,
            controller: _notesController,
          ),
          SizedBox(height: AppSpacing.sm),
          BlocBuilder<LeavesBloc, LeavesState>(
            bloc: context.read<LeavesBloc>(),
            builder: (context, state) {
              final isLoading = state is LeavesLoading;
              return ElevatedButton(
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
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: context.colorScheme.onPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('حفظ الاجازه'),
              );
            },
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}