import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              _buildGreetingCard(context),
              const SizedBox(height: 16),
              _buildFinancialYearCard(context),
              const SizedBox(height: 16),
              _buildSmartAlerts(context),
              const SizedBox(height: 16),
              _buildBalancesSection(context),
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

  Widget _buildGreetingCard(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، ${state.settings.employeeName} 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                state.settings.jobTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFinancialYearCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              'السنة المالية الحالية: ${FinancialYearCalculator.financialYearString}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartAlerts(BuildContext context) {
    return BlocBuilder<LeavesBloc, LeavesState>(
      builder: (context, state) {
        if (state is LeavesLoaded) {
          List<Widget> alerts = [];
          final currentMonth = DateTime.now().month;

          if (currentMonth == 6) {
            alerts.add(
              _alertBanner(
                context,
                'اقترب موعد انتهاء السنة المالية، يرجى مراجعة أرصدتك.',
              ),
            );
          }

          if (state.balance.remainingRegular <= 3) {
            alerts.add(
              _alertBanner(
                context,
                'تنبيه: رصيد إجازاتك الاعتيادية قارب على النفاذ!',
                isWarning: true,
              ),
            );
          }

          return Column(children: alerts);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _alertBanner(
    BuildContext context,
    String message, {
    bool isWarning = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning
            ? Colors.red.withAlpha(1)
            : Colors.orange.withAlpha(1),
        border: Border.all(color: isWarning ? Colors.red : Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: isWarning ? Colors.red : Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: isWarning ? Colors.red : Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalancesSection(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<LeavesBloc, LeavesState>(
          builder: (context, leavesState) {
            if (settingsState is SettingsLoaded &&
                leavesState is LeavesLoaded) {
              return Row(
                children: [
                  Expanded(
                    child: _buildCircularIndicator(
                      context,
                      'اعتيادي',
                      leavesState.balance.remainingRegular,
                      settingsState.settings.totalRegularLeaves,
                      AppColors.regularLeaveColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCircularIndicator(
                      context,
                      'عارضه',
                      leavesState.balance.remainingCasual,
                      settingsState.settings.totalCasualLeaves,
                      AppColors.casualLeaveColor,
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget _buildCircularIndicator(
    BuildContext context,
    String title,
    int remaining,
    int total,
    Color color,
  ) {
    double progress = total > 0 ? (remaining / total) : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: color.withAlpha(2),
                    color: color,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$remaining',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      'من $total',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
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

  void _pickDate(bool isStart) async {
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now.isBefore(startFinYear)
          ? startFinYear
          : (now.isAfter(endFinYear) ? endFinYear : now),
      firstDate: startFinYear,
      lastDate: endFinYear,
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          if (_endDate != null && _endDate!.isBefore(_startDate!)){

            _endDate = null;
          }
        } else {
          _endDate = date;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            DropdownMenuItem(value: LeaveType.regular, child: Text('اعتيادية')),
            DropdownMenuItem(value: LeaveType.casual, child: Text('عارضة')),
          ],
          onChanged: (val) => setState(() => _selectedType = val!),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _startDate != null
                      ? _startDate!.toString().split(' ')[0]
                      : 'تاريخ البداية',
                ),
                onPressed: () => _pickDate(true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _endDate != null
                      ? _endDate!.toString().split(' ')[0]
                      : 'تاريخ النهاية',
                ),
                onPressed: _startDate == null ? null : () => _pickDate(false),
              ),
            ),
          ],
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
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
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ الإجازة'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
