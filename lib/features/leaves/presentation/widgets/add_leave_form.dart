// lib/features/leaves/presentation/widgets/add_leave_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/utils/app_notifications.dart';
import 'package:vacation_tracker/core/utils/extenstions/date_extension.dart';
import 'package:vacation_tracker/core/utils/financial_year_calculator.dart';
import 'package:vacation_tracker/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:vacation_tracker/core/utils/enums/leave_type.dart';
import 'package:vacation_tracker/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:vacation_tracker/core/widgets/custom_text_field.dart'; // استدعاء حقل الإدخال الموحد

class AddLeaveForm extends StatefulWidget {
  final BuildContext parentContext;
  const AddLeaveForm({super.key, required this.parentContext});

  @override
  AddLeaveFormState createState() => AddLeaveFormState();
}

class AddLeaveFormState extends State<AddLeaveForm> {
  LeaveType _selectedType = LeaveType.regular;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _notesController = TextEditingController();

  void _selectLeaveDate() async {
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;
    final now = DateTime.now();

    if (_selectedType == LeaveType.casual) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now.isBefore(startFinYear) ? startFinYear : (now.isAfter(endFinYear) ? endFinYear : now),
        firstDate: startFinYear,
        lastDate: endFinYear,
        helpText: 'اختر يوم الإجازة العارضة',
        builder: (context, child) => Theme(data: Theme.of(context), child: child!),
      );

      if (picked != null) {
        setState(() {
          _startDate = picked;
          _endDate = picked;
        });
      }
    } else {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: startFinYear,
        lastDate: endFinYear,
        initialDateRange: _startDate != null && _endDate != null && _startDate != _endDate
            ? DateTimeRange(start: _startDate!, end: _endDate!)
            : null,
        saveText: 'تأكيد',
        cancelText: 'إلغاء',
        helpText: 'اختر فترة الإجازة الاعتيادية (من - إلى)',
        builder: (context, child) => Theme(data: Theme.of(context), child: child!),
      );

      if (picked != null) {
        setState(() {
          _startDate = picked.start;
          _endDate = picked.end;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.black12 : Colors.grey.shade50;

    return BlocListener<LeavesBloc, LeavesState>(
      bloc: widget.parentContext.read<LeavesBloc>(),
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. مؤشر السحب (Drag Handle)
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 2. عنوان النافذة بشكل أنيق
            Row(
              children: [
                Icon(Icons.edit_calendar_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'تسجيل إجازة جديدة',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. حقل نوع الإجازة (مصمم ليتطابق مع CustomTextField)
            DropdownButtonFormField<LeaveType>(
              initialValue: _selectedType,
              dropdownColor: colorScheme.surface,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontFamily: 'Cairo'),
              decoration: InputDecoration(
                labelText: 'نوع الإجازة',
                labelStyle: TextStyle(color: colorScheme.onSurface.withAlpha(150)),
                prefixIcon: Icon(Icons.category_rounded, color: colorScheme.primary),
                filled: true,
                fillColor: fillColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: const [
                DropdownMenuItem(value: LeaveType.regular, child: Text('اعتيادية')),
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

            // 4. زر اختيار التاريخ (تحول لشكله كحقل إدخال عصري)
            InkWell(
              onTap: _selectLeaveDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _startDate != null ? colorScheme.primary : borderColor,
                    width: _startDate != null ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range_rounded,
                      color: _startDate != null ? colorScheme.primary : colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _startDate == null
                            ? (_selectedType == LeaveType.casual ? 'اضغط لاختيار يوم الإجازة' : 'اضغط لاختيار فترة الإجازة')
                            : (_selectedType == LeaveType.casual
                                  ? _startDate!.toFormattedDate()
                                  : '${_startDate!.toFormattedDate()}   إلى   ${_endDate!.toFormattedDate()}'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _startDate != null ? FontWeight.bold : FontWeight.normal,
                          color: _startDate != null ? colorScheme.primary : colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. حقل الملاحظات باستخدام المكون المخصص الموحد
            CustomTextField(
              label: 'ملاحظات (اختياري)',
              icon: Icons.notes_rounded,
              controller: _notesController,
            ),
            const SizedBox(height: 8),

            // 6. زر الحفظ (بتصميم أنيق بدون ظل وحواف دائرية)
            BlocBuilder<LeavesBloc, LeavesState>(
              bloc: widget.parentContext.read<LeavesBloc>(),
              builder: (context, state) {
                final isLoading = state is LeavesLoading;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0, // إزالة الظل لمظهر Flat عصري
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_startDate != null && _endDate != null) {
                            final daysCount = _endDate!.difference(_startDate!).inDays + 1;
                            final record = LeaveRecord(
                              id: 0,
                              leaveType: _selectedType,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              daysCount: daysCount,
                              notes: _notesController.text,
                            );
                            widget.parentContext.read<LeavesBloc>().add(AddNewLeaveEvent(record));
                          } else {
                            AppNotifications.showWarning(context, 'الرجاء اختيار التاريخ أولاً');
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5),
                        )
                      : const Text('حفظ الإجازة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}