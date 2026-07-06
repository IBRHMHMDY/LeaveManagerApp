import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/di/injection_container.dart' as di;
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_event.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_state.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_upcoming_holiday_card.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_balances_section.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_current_month_leaves.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_financialyear_card.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_greeting_card.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_events.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:leave_manager/shared/widgets/build_alert_banners.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeavesBloc, LeavesState>(
      listener: (context, state) {
        // إظهار رسالة الخطأ إذا تم رفض تسجيل الإجازة
        if (state is LeavesError) {
          Navigator.pop(context);
          AppNotifications.showError(context, state.message);
        }
        // إظهار رسالة نجاح عند إتمام الحفظ
        else if (state is LeaveAddedSuccess) {
          AppNotifications.showSuccess(context, 'تم خصم يوم اجازه من رصيدك وتسجيله بدفتر اجازاتك.');
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<SettingsBloc>().add(LoadSettingsEvent());
            context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              BuildGreetingCard(key: key),
              const SizedBox(height: 16),
              BuildFinancialYearCard(context),
              const SizedBox(height: 16),
              BuildAlertBanners(key: key,),
              const SizedBox(height: 16),
              BlocProvider(
                create: (context) {
                  // 1. استخراج البلد من إعدادات المستخدم
                  final settingsState = context.read<SettingsBloc>().state;
                  final country = settingsState is SettingsLoaded ? settingsState.settings.selectedCountry : 'مصر';
                  
                  // 2. حقن الـ Bloc وإطلاق حدث جلب البيانات
                  return di.sl<HolidaysBloc>()..add(LoadHolidaysEvent(country));
                },
                child: BlocBuilder<HolidaysBloc, HolidaysState>(
                  builder: (context, state) {
                    // 3. تمرير الإجازة القادمة إذا كانت الحالة Loaded
                    return UpcomingHolidayCard(
                      nextHoliday: state is HolidaysLoaded ? state.upcomingHoliday : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              BuildBalancesSection(context),
              const SizedBox(height: 24),
              BuildCurrentMonthLeaves(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}


