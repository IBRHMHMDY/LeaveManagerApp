// lib/features/leaves/presentation/shared_widgets/add_leave_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/core/utils/leave_calculator.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_event.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_state.dart';
import 'package:leave_manager/features/rest_allowance/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/core/di/injection_container.dart' as di;

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

  // --- متغيرات الحاسبة الذكية ---
  int _actualDaysCount = 0; 
  List<Holiday> _officialHolidays = []; 
  late HolidaysBloc _holidaysBloc; 

  @override
  void initState() {
    super.initState();
    _holidaysBloc = di.sl<HolidaysBloc>()..add(LoadHolidaysEvent());
  }

  @override
  void dispose() {
    _holidaysBloc.close(); // إغلاق الـ BLoC لمنع تسرب الذاكرة (Memory Leak)
    _notesController.dispose();
    super.dispose();
  }

  // --- دالة الحساب الذكية ---
  void _calculateActualDays() {
    if (_startDate != null && _endDate != null) {
      final days = LeaveCalculator.calculateActualLeaveDays(
        startDate: _startDate!,
        endDate: _endDate!,
        officialHolidays: _officialHolidays,
      );
      setState(() {
        _actualDaysCount = days;
      });
    }
  }

  void _selectLeaveDate() async {
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;

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
      helpText: 'اختر فترة الإجازة (من - إلى)',
      builder: (context, child) =>
          Theme(data: Theme.of(context), child: child!),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      // استدعاء الحساب بعد اختيار التواريخ
      _calculateActualDays();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.black12 : Colors.grey.shade50;

    return MultiBlocListener(
      listeners: [
        BlocListener<LeavesBloc, LeavesState>(
          bloc: widget.parentContext.read<LeavesBloc>(),
          listener: (context, state) {
            if (state is LeaveAddedSuccess) {
              Navigator.pop(context);
            }
          },
        ),
        // الاستماع لجلب قائمة الإجازات الرسمية من قاعدة البيانات
        BlocListener<HolidaysBloc, HolidaysState>(
          bloc: _holidaysBloc,
          listener: (context, state) {
            if (state is HolidaysLoaded) {
              _officialHolidays = state.holidays;
              _calculateActualDays(); // إعادة الحساب التلقائي إذا كانت التواريخ مختارة مسبقاً
            }
          },
        ),
      ],
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

            // 3. حقل نوع الإجازة
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
                  _actualDaysCount = 0; // تصفير الأيام عند التغيير
                });
              },
            ),
            const SizedBox(height: 16),

            // 4. زر اختيار التاريخ
            InkWell(
              onTap: _selectLeaveDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _startDate != null
                        ? colorScheme.primary
                        : borderColor,
                    width: _startDate != null ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range_rounded,
                      color: _startDate != null
                          ? colorScheme.primary
                          : colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _startDate == null
                            ? 'اضغط لاختيار فترة الإجازة'
                            : '${_startDate!.toFormattedDate()}   إلى   ${_endDate!.toFormattedDate()}',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _startDate != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _startDate != null
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 5. عرض عدد الأيام المخصومة بذكاء للموظف (ميزة جديدة للواجهة) ---
            if (_startDate != null && _endDate != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.primary.withAlpha(50)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _actualDaysCount > 0 
                          ? 'سيتم خصم ( $_actualDaysCount ) أيام فعلية من رصيدك'
                          : 'لا يوجد خصم للأيام (التاريخ ضمن الإجازات الرسمية)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _actualDaysCount > 0 ? colorScheme.primary : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 6. حقل الملاحظات
            CustomTextField(
              label: 'ملاحظات (اختياري)',
              icon: Icons.notes_rounded,
              controller: _notesController,
            ),
            const SizedBox(height: 8),

            // 7. زر الحفظ
            BlocBuilder<LeavesBloc, LeavesState>(
              bloc: widget.parentContext.read<LeavesBloc>(),
              builder: (context, state) {
                final isLoading = state is LeavesLoading;
                
                // يتم تعطيل زر الحفظ إذا كان التطبيق يحمل البيانات أو إذا كانت الأيام الفعلية صفر!
                final disableButton = isLoading || (_startDate != null && _actualDaysCount == 0);

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
                  onPressed: disableButton
                      ? null
                      : () {
                          if (_startDate != null && _endDate != null) {
                            final record = LeaveRecord(
                              id: 0,
                              leaveType: _selectedType,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              // هنا السحر: نمرر الأيام المفلترة بدلاً من الطرح المباشر!
                              daysCount: _actualDaysCount, 
                              notes: _notesController.text,
                            );
                            widget.parentContext.read<LeavesBloc>().add(
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
      ),
    );
  }
}