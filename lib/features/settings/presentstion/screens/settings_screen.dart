import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vacation_tracker/core/router/app_router.dart';
import 'package:vacation_tracker/core/utils/app_notifications.dart';
import 'package:vacation_tracker/core/utils/extenstions/string_extension.dart';
import 'package:vacation_tracker/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:vacation_tracker/core/widgets/custom_text_field.dart';
import 'package:vacation_tracker/features/settings/domain/entities/settings_entity.dart';
import 'package:vacation_tracker/features/settings/presentstion/bloc/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  final bool isFirstTime;
  const SettingsScreen({super.key, required this.isFirstTime});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController(text: 'موظف');
  final _regularLeavesController = TextEditingController(text: '21');
  final _casualLeavesController = TextEditingController(text: '7');

  @override
  void initState() {
    super.initState();
    // 1. استدعاء البيانات مبكراً إذا لم تكن هذه المرة الأولى لضمان ملء الحقول
    _loadInitialData();
  }

  void _loadInitialData() {
    if (!widget.isFirstTime) {
      final state = context.read<SettingsBloc>().state;
      if (state is SettingsLoaded) {
        _populateFields(state.settings);
      }
    }
  }

  void _populateFields(Settings settings) {
    _nameController.text = settings.employeeName;
    _jobController.text = settings.jobTitle;
    _regularLeavesController.text = settings.totalRegularLeaves.toString();
    _casualLeavesController.text = settings.totalCasualLeaves.toString();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // إخفاء لوحة المفاتيح عند الضغط على حفظ
      FocusScope.of(context).unfocus();

      final settings = Settings(
        id: 1,
        employeeName: _nameController.text.trim(),
        jobTitle: _jobController.text.trim(),
        totalRegularLeaves: _regularLeavesController.text.toIntSafely(),
        totalCasualLeaves: _casualLeavesController.text.toIntSafely(),
      );

      context.read<SettingsBloc>().add(SaveSettingsEvent(settings));
    }
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'مطلوب';
    if (value.toIntSafely() == 0 &&
        value.trim() != '0' &&
        value.trim() != '٠') {
      return 'أرقام فقط';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded && !widget.isFirstTime) {
          if (_nameController.text.isEmpty) {
            _populateFields(state.settings);
          }
        } else if (state is SettingsSavedSuccess) {
          AppNotifications.showSuccess(context, 'تم حفظ الإعدادات بنجاح');

          // تحديث بيانات الإعدادات في الـ Bloc
          context.read<SettingsBloc>().add(LoadSettingsEvent());
          // 2. تحديث أرصدة الإجازات فوراً لكي تنعكس الأرصدة الجديدة على الشاشة الرئيسية
          context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());

          // 3. التوجيه يتم **فقط** إذا كانت هذه الشاشة الأولى
          if (widget.isFirstTime) {
            context.go(AppRouter.home);
          }
          // إذا لم تكن المرة الأولى سيبقى المستخدم بداخل التبويب بهدوء وسلاسة
        } else if (state is SettingsError) {
          AppNotifications.showError(context, state.message);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'البيانات الشخصية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'اسم الموظف',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'مطلوب' : null,
                ),

                CustomTextField(
                  label: 'المسمى الوظيفي',
                  icon: Icons.work_outline,
                  controller: _jobController,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'مطلوب' : null,
                ),

                const SizedBox(height: 16),
                const Text(
                  'الأرصدة السنوية المستحقة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'إجمالي الاعتيادي',
                        icon: Icons.event_available,
                        controller: _regularLeavesController,
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'إجمالي العارضة',
                        icon: Icons.event_busy,
                        controller: _casualLeavesController,
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 4. تحسين زر الحفظ (إظهار مؤشر تحميل ومنع الضغط المتكرر)
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    final isLoading = state is SettingsLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      onPressed: isLoading ? null : _saveSettings,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'حفظ الإعدادات',
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  },
                ),

                // 5. إخفاء زر مسح السجلات تماماً إذا كان المستخدم يفتح التطبيق لأول مرة
                if (!widget.isFirstTime) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade700),
                    ),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text(
                      'تصفير الأرصدة (مسح سجلات الإجازات)',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('تأكيد التصفير'),
                          content: const Text(
                            'هل أنت متأكد من أنك تريد مسح جميع سجلات الإجازات؟ هذا الإجراء لا يمكن التراجع عنه.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('إلغاء'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                context.read<LeavesBloc>().add(
                                  ResetAllLeavesEvent(),
                                );
                                Navigator.pop(ctx);
                                AppNotifications.showSuccess(
                                  context,
                                  'تم تصفير الأرصدة بنجاح',
                                );
                              },
                              child: const Text('نعم، مسح'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
