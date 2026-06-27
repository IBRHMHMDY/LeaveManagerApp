import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/constants/app_colors.dart';
import 'package:vacation_tracker/core/utils/app_notifications.dart';
import 'package:vacation_tracker/core/utils/date_extension.dart';
import 'package:vacation_tracker/core/utils/financial_year_calculator.dart';
import 'package:vacation_tracker/domain/entities/leave_record.dart';
import 'package:vacation_tracker/domain/entities/leave_type.dart';
import 'package:vacation_tracker/presentation/blocs/leaves/leaves_bloc.dart';

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

  // الدالة الذكية لاختيار التاريخ بناءً على نوع الإجازة
  void _selectLeaveDate() async {
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;
    final now = DateTime.now();

    if (_selectedType == LeaveType.casual) {
      // --- حالة الإجازة العارضة: اختيار يوم واحد فقط ---
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now.isBefore(startFinYear)
            ? startFinYear
            : (now.isAfter(endFinYear) ? endFinYear : now),
        firstDate: startFinYear,
        lastDate: endFinYear,
        helpText: 'اختر يوم الإجازة العارضة',
        builder: (context, child) {
          return Theme(data: Theme.of(context), child: child!);
        },
      );

      if (picked != null) {
        setState(() {
          _startDate = picked;
          _endDate = picked;
        });
      }
    } else {
      // --- حالة الإجازة الاعتيادية: اختيار مدى زمني ---
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: startFinYear,
        lastDate: endFinYear,
        initialDateRange:
            _startDate != null && _endDate != null && _startDate != _endDate
            ? DateTimeRange(start: _startDate!, end: _endDate!)
            : null,
        saveText: 'تأكيد',
        cancelText: 'إلغاء',
        helpText: 'اختر فترة الإجازة الاعتيادية (من - إلى)',
        builder: (context, child) {
          return Theme(data: Theme.of(context), child: child!);
        },
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
    return BlocListener<LeavesBloc, LeavesState>(
      bloc: widget.parentContext.read<LeavesBloc>(),
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تسجيل إجازة جديدة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<LeaveType>(
            initialValue: _selectedType,
            decoration: const InputDecoration(
              labelText: 'نوع الإجازة',
              border: OutlineInputBorder(),
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
                // تنظيف التواريخ عند تغيير النوع لعدم خلط البيانات
                _startDate = null;
                _endDate = null;
              });
            },
          ),
          const SizedBox(height: 16),

          // زر اختيار التاريخ التكيفي
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: _startDate != null
                    ? AppColors.primaryTeal
                    : Colors.grey.shade400,
              ),
            ),
            icon: Icon(
              Icons.date_range,
              color: _startDate != null ? AppColors.primaryTeal : Colors.grey,
            ),
            label: Text(
              _startDate == null
                  ? (_selectedType == LeaveType.casual
                        ? 'اضغط لاختيار يوم الإجازة'
                        : 'اضغط لاختيار فترة الإجازة')
                  : (_selectedType == LeaveType.casual
                        ? _startDate!.toFormattedDate()
                        : '${_startDate!.toFormattedDate()}   إلى   ${_endDate!.toFormattedDate()}'),
              style: TextStyle(
                fontSize: 16,
                color: _startDate != null
                    ? AppColors.primaryTeal
                    : Colors.black87,
              ),
            ),
            onPressed: _selectLeaveDate,
          ),

          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'ملاحظات (اختياري)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          BlocBuilder<LeavesBloc, LeavesState>(
            bloc: widget.parentContext.read<LeavesBloc>(),
            builder: (context, state) {
              final isLoading = state is LeavesLoading;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                          widget.parentContext.read<LeavesBloc>().add(
                            AddNewLeaveEvent(record),
                          );
                        } else {
                          AppNotifications.showWarning(
                            context,
                            'الرجاء اختيار التاريخ أولاً',
                          );
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('حفظ الإجازة', style: TextStyle(fontSize: 16)),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
