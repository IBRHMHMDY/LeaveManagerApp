import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/utils/date_extension.dart';
import 'package:vacation_tracker/presentation/widgets/build_balances_section.dart';
import 'package:vacation_tracker/presentation/widgets/build_current_month_leaves.dart';
import 'package:vacation_tracker/presentation/widgets/build_financialyear_card.dart';
import 'package:vacation_tracker/presentation/widgets/build_greeting_card.dart';
import 'package:vacation_tracker/presentation/widgets/build_smart_alerts.dart';
import '../../core/utils/financial_year_calculator.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/leave_type.dart';
import '../../domain/entities/leave_record.dart';
import '../blocs/leaves/leaves_bloc.dart';
import '../blocs/settings/settings_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeavesBloc, LeavesState>(
      listener: (context, state) {
        // إظهار رسالة الخطأ إذا تم رفض تسجيل الإجازة
        if (state is LeavesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        // إظهار رسالة نجاح عند إتمام الحفظ
        else if (state is LeaveAddedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل الإجازة بنجاح'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('لوحة المعلومات'), centerTitle: false),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<SettingsBloc>().add(LoadSettingsEvent());
            context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              BuildGreetingCard(context),
              const SizedBox(height: 16),
              BuildFinancialYearCard(context),
              const SizedBox(height: 16),
              BuildSmartAlerts(context),
              const SizedBox(height: 16),
              BuildBalancesSection(context),
              const SizedBox(height: 24),
              BuildCurrentMonthLeaves(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddLeaveBottomSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('إجازة جديدة'),
          backgroundColor: AppColors.accentCoral,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

 
  

  void _showAddLeaveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: _AddLeaveForm(parentContext: context),
      ),
    );
  }
}

class _AddLeaveForm extends StatefulWidget {
  final BuildContext parentContext;
  const _AddLeaveForm({required this.parentContext});

  @override
  __AddLeaveFormState createState() => __AddLeaveFormState();
}

class __AddLeaveFormState extends State<_AddLeaveForm> {
  LeaveType _selectedType = LeaveType.regular;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _notesController = TextEditingController();

  void _pickDateRange() async {
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: startFinYear,
      lastDate: endFinYear,
      // إذا كان هناك تاريخ مختار مسبقاً، نظهره كقيمة مبدئية
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      
      // --- تخصيص النصوص لتناسب اللغة العربية ---
      saveText: 'تأكيد',
      cancelText: 'إلغاء',
      helpText: 'اختر فترة الإجازة (من - إلى)',
      errorInvalidRangeText: 'نطاق غير صحيح',
      
      // ضمان استجابة الأداة للوضع الليلي/النهاري للنظام
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // يتم تحديث البداية والنهاية معاً في خطوة واحدة
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدمنا BlocListener هنا للتحكم في سلوك نافذة الـ BottomSheet
    return BlocListener<LeavesBloc, LeavesState>(
      bloc: widget.parentContext.read<LeavesBloc>(), // ربط مع الـ BLoC للشاشة الأب
      listener: (context, state) {
        if (state is LeaveAddedSuccess) {
          // يتم إغلاق النافذة فقط في حالة النجاح!
          Navigator.pop(context);
        }
        // ملاحظة: حالة الخطأ (LeavesError) يتم التقاطها بالفعل وعرضها كـ SnackBar 
        // في الـ BlocListener الموجود في أعلى الـ HomeScreen، لذلك لا نغلق النافذة هنا.
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'إجازة جديدة',
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
              DropdownMenuItem(value: LeaveType.regular, child: Text('اعتيادية')),
              DropdownMenuItem(value: LeaveType.casual, child: Text('عارضة')),
            ],
            onChanged: (val) => setState(() => _selectedType = val!),
          ),
          const SizedBox(height: 16),
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
              _startDate != null && _endDate != null
                  // نستخدم الـ Extension الذي أنشأناه سابقاً لتوحيد الصيغة
                  ? '${_startDate!.toFormattedDate()}   إلى   ${_endDate!.toFormattedDate()}'
                  : 'اضغط لاختيار فترة الإجازة',
              style: TextStyle(
                fontSize: 16,
                color: _startDate != null ? AppColors.primaryTeal : Colors.black87,
              ),
            ),
            onPressed: _pickDateRange,
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
          
          // الاعتماد على حالة الـ Bloc لتغيير شكل زر الحفظ
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
                onPressed: isLoading ? null : () {
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
                    widget.parentContext.read<LeavesBloc>().add(
                      AddNewLeaveEvent(record),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء اختيار التواريخ أولاً')),
                    );
                  }
                },
                child: isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text('حفظ الإجازة', style: TextStyle(fontSize: 16)),
              );
            }
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
