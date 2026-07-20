import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              fontSize: 16,
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
              ),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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
          const SizedBox(height: 16),

          // استخدام المكون المستقل الجديد لاختيار التاريخ
          CustomDateRangePickerField(
            startDate: _startDate,
            endDate: _endDate,
            hintText: 'اضغط لاختيار فترة الإجازة',
            firstDate: FinancialYearCalculator.currentFinancialYearStart,
            // تحديد الحد الأقصى كاليوم الحالي لمنع اختيار تواريخ مستقبلية
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
          const SizedBox(height: 16),

          // حقل الملاحظات
          CustomTextField(
            label: 'ملاحظات (اختياري)',
            icon: Icons.notes_rounded,
            controller: _notesController,
          ),
          const SizedBox(height: 8),

          // زر الحفظ
          BlocBuilder<LeavesBloc, LeavesState>(
            bloc: context.read<LeavesBloc>(),
            builder: (context, state) {
              final isLoading = state is LeavesLoading;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'حفظ الإجازة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
