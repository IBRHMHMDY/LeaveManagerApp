import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _jobController = TextEditingController();
  final _regularLeavesController = TextEditingController(text: '21'); 
  final _casualLeavesController = TextEditingController(text: '7');   

  @override
  void initState() {
    super.initState();
    // تمت إزالة محاولة القراءة من هنا لأننا سنعتمد على المستمع (Listener) أدناه
  }

  int _parseNumberSafely(String value) {
    String normalized = value
        .trim()
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
    
    return int.tryParse(normalized) ?? 0;
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final settings = Settings(
        id: 1, 
        employeeName: _nameController.text.trim(),
        jobTitle: _jobController.text.trim(),
        totalRegularLeaves: _parseNumberSafely(_regularLeavesController.text),
        totalCasualLeaves: _parseNumberSafely(_casualLeavesController.text),
      );
      
      context.read<SettingsBloc>().add(SaveSettingsEvent(settings));
    }
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'مطلوب';
    if (_parseNumberSafely(value) == 0 && value.trim() != '0') {
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
            _regularLeavesController.text = state.settings.totalRegularLeaves.toString();
            _casualLeavesController.text = state.settings.totalCasualLeaves.toString();
          }
        } 
        // 2. معالجة نجاح الحفظ
        else if (state is SettingsSavedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ الإعدادات بنجاح'), backgroundColor: Colors.green),
          );
          context.read<SettingsBloc>().add(LoadSettingsEvent());
          
          if (widget.isFirstTime) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            );
          }
        } 
        // 3. معالجة الأخطاء
        else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.isFirstTime ? 'إعداد الحساب' : 'الإعدادات')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('البيانات الشخصية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'اسم الموظف', border: OutlineInputBorder()),
                  validator: (val) => val == null || val.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jobController,
                  decoration: const InputDecoration(labelText: 'المسمى الوظيفي', border: OutlineInputBorder()),
                  validator: (val) => val == null || val.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 32),
                const Text('الأرصدة السنوية المستحقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _regularLeavesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'إجمالي الاعتيادي', border: OutlineInputBorder()),
                        validator: _numberValidator,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _casualLeavesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'إجمالي العارض', border: OutlineInputBorder()),
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
                  child: const Text('حفظ الإعدادات', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}