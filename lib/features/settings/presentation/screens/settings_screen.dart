// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/string_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/backup_restore/presentation/widgets/backup_settings_section.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:leave_manager/features/settings/presentation/widgets/danger_zone_section.dart';
import 'package:leave_manager/features/settings/presentation/widgets/settings_form_section.dart';
import 'package:leave_manager/features/settings/presentation/widgets/settings_header.dart';
import 'package:leave_manager/features/settings/presentation/widgets/theme_selection_section.dart';
import 'package:leave_manager/features/settings/presentation/widgets/notification_settings_section.dart'; // المكون الجديد
import 'package:leave_manager/shared/widgets/widgets.dart';

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
  final _regularLeavesController = TextEditingController(text: '15');
  final _casualLeavesController = TextEditingController(text: '7');

  // --- متغيرات حالة الإشعارات الجديدة ---
  bool _enableNotifications = true;
  int _daysBeforeHolidayAlert = 2;
  String _notificationTime = '10:00';
  late bool _isFirstTime;

  @override
  void initState() {
    super.initState();
    _isFirstTime = widget.isFirstTime;
    _loadInitialData();
  }

  void _loadInitialData() {
    if (!_isFirstTime) {
      final state = context.read<SettingsBloc>().state;
      if (state is SettingsLoaded) {
        _populateFields(state.settings);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    _regularLeavesController.dispose();
    _casualLeavesController.dispose();
    super.dispose();
  }

  void _populateFields(Settings settings) {
    _nameController.text = settings.employeeName;
    _jobController.text = settings.jobTitle;
    _regularLeavesController.text = settings.totalRegularLeaves.toString();
    _casualLeavesController.text = settings.totalCasualLeaves.toString();

    setState(() {
      _enableNotifications = settings.enableNotifications;
      _daysBeforeHolidayAlert = settings.daysBeforeHolidayAlert;
      _notificationTime = settings.notificationTime;
    });
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final settings = Settings(
        id: 1,
        employeeName: _nameController.text.trim(),
        jobTitle: _jobController.text.trim(),
        totalRegularLeaves: _regularLeavesController.text.toIntSafely(),
        totalCasualLeaves: _casualLeavesController.text.toIntSafely(),
        enableNotifications: _enableNotifications,
        daysBeforeHolidayAlert: _daysBeforeHolidayAlert,
        notificationTime: _notificationTime,
      );

      context.read<SettingsBloc>().add(SaveSettingsEvent(settings));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded && !_isFirstTime) {
          if (_nameController.text.isEmpty) {
            _populateFields(state.settings);
          }
        } else if (state is SettingsSavedSuccess) {
          context.read<SettingsBloc>().add(LoadSettingsEvent());
          context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
          context.read<RestAllowancesBloc>().add(LoadRestAllowancesEvent());
          context.read<HolidaysCubit>().loadHolidays();
          AppToast.showSuccess(context, 'تم حفظ الإعدادات بنجاح.');
          if (_isFirstTime) {
            setState(() {
              _isFirstTime = false;
            });
          }
          context.go(AppRouter.home);
        } else if (state is SettingsError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: !widget.isFirstTime ? const SettingsHeader() : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Data Form ---
                SettingsFormSection(
                  nameController: _nameController,
                  jobController: _jobController,
                  regularLeavesController: _regularLeavesController,
                  casualLeavesController: _casualLeavesController,
                ),
                const SizedBox(height: AppSpacing.lg),
                // --- Notifications ---
                NotificationSettingsSection(
                  isEnabled: _enableNotifications,
                  daysBefore: _daysBeforeHolidayAlert,
                  notificationTime: _notificationTime,
                  onToggle: (value) =>
                      setState(() => _enableNotifications = value),
                  onDaysChanged: (value) =>
                      setState(() => _daysBeforeHolidayAlert = value),
                  onTimeChanged: (value) =>
                      setState(() => _notificationTime = value),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Save Settings button
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    final isLoading = state is SettingsLoading;
                    return AppPrimaryButton(
                      onPressed: isLoading ? null : _saveSettings,
                      label: 'حفظ الإعدادات',
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                // --- Backup & Restore ---
                const BackupSettingsSection(),
                const SizedBox(height: AppSpacing.lg),
                // --- Dark & Light Themes ---
                const ThemeSelectionSection(),
                const SizedBox(height: AppSpacing.md),
                !widget.isFirstTime
                    ? const DangerZoneSection()
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
