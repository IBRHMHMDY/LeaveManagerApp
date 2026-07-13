import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';

class AddRestAllowanceBottomSheet extends StatefulWidget {
  const AddRestAllowanceBottomSheet({super.key});

  @override
  State<AddRestAllowanceBottomSheet> createState() => _AddRestAllowanceBottomSheetState();
}

class _AddRestAllowanceBottomSheetState extends State<AddRestAllowanceBottomSheet> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final TextEditingController _notesController = TextEditingController();

  // دالة لحساب عدد الأيام
  double get _daysCount => _endDate.difference(_startDate).inDays + 1.0;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate; // ضبط تاريخ النهاية تلقائياً إذا كان قبل البداية
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (_endDate.isBefore(_startDate)) {
      AppNotifications.showError(context, 'تاريخ النهاية يجب أن يكون بعد تاريخ البداية');
      return;
    }

    // تجهيز الكيان (Entity) الخاص بالإجازة
    final leaveRecord = LeaveRecord(
      id: DateTime.now().millisecondsSinceEpoch, // توليد معرف فريد
      leaveType: LeaveType.restAllowance, // نوع الإجازة: بدل راحة
      startDate: _startDate,
      endDate: _endDate,
      daysCount: _daysCount.toInt(),
      notes: _notesController.text.trim(),
    );

    // إرسال الحدث لـ LeavesBloc
    context.read<LeavesBloc>().add(AddNewLeaveEvent(leaveRecord));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<LeavesBloc, LeavesState>(
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          Navigator.pop(context); // إغلاق النافذة عند النجاح
          AppNotifications.showSuccess(context, 'تم تسجيل بدل الراحة بنجاح');
        } else if (state is LeavesError) {
          AppNotifications.showError(context, state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'تسجيل بدل راحة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDateSelector(
                      context,
                      label: 'من تاريخ',
                      date: _startDate,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateSelector(
                      context,
                      label: 'إلى تاريخ',
                      date: _endDate,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'المدة: ${_daysCount.toInt()} يوم',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'ملاحظات (اختياري)',
                icon: Icons.note_alt_rounded,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('تسجيل وخصم من الرصيد', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, {required String label, required DateTime date, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(
              DateFormat('yyyy/MM/dd').format(date),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}