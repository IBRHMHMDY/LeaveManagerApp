import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/utils/app_notifications.dart';
import 'package:vacation_tracker/core/utils/string_extension.dart';
import 'package:vacation_tracker/presentation/blocs/leaves/leaves_bloc.dart';
import 'package:vacation_tracker/presentation/widgets/custom_text_field.dart';
import '../../domain/entities/settings.dart';
import '../blocs/settings/settings_bloc.dart';
import 'main_navigation_screen.dart';

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
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
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
        // 1. الاستماع لوصول البيانات وتعبئة الحقول بها
        if (state is SettingsLoaded && !widget.isFirstTime) {
          // نتحقق من أن الاسم فارغ حتى لا نمسح ما يكتبه المستخدم إذا تم تحديث الحالة لسبب آخر
          if (_nameController.text.isEmpty) {
            _nameController.text = state.settings.employeeName;
            _jobController.text = state.settings.jobTitle;
            _regularLeavesController.text = state.settings.totalRegularLeaves
                .toString();
            _casualLeavesController.text = state.settings.totalCasualLeaves
                .toString();
          }
        }
        // 2. معالجة نجاح الحفظ
        else if (state is SettingsSavedSuccess) {
          AppNotifications.showSuccess(context, 'تم حفظ الإعدادات بنجاح');
          context.read<SettingsBloc>().add(LoadSettingsEvent());
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
        // 3. معالجة الأخطاء
        else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isFirstTime ? 'إعداد الحساب' : 'الإعدادات'),
        ),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: _saveSettings,
                  child: const Text(
                    'حفظ الإعدادات',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
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
            ),
          ),
        ),
      ),
    );
  }
}
