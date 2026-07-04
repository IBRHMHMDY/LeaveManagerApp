import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_balances_section.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_current_month_leaves.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_financialyear_card.dart';
import 'package:leave_manager/features/leaves/presentation/home/widgets/build_greeting_card.dart';
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


