import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استيراد متحكمات الشاشة الرئيسية
import 'package:leave_manager/features/home/presentation/cubit/home_cubit.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_state.dart';

// استيراد BLoCs الميزات الأخرى للاستماع لتغيراتها
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';

// استيراد المكونات الفرعية
import 'package:leave_manager/features/home/presentation/widgets/balances_loading_shimmer.dart';
import 'package:leave_manager/features/home/presentation/widgets/build_balances_section.dart';
import 'package:leave_manager/features/home/presentation/widgets/build_current_month_leaves.dart';
import 'package:leave_manager/features/home/presentation/widgets/build_financialyear_card.dart';
import 'package:leave_manager/features/home/presentation/widgets/build_greeting_card.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:leave_manager/features/home/presentation/widgets/build_alert_banners.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LeavesBloc, LeavesState>(
          listener: (context, state) {
            if (state is LeaveAddedSuccess ||
                state is LeaveDeletedSuccess ||
                state is LeavesResetSuccess) {
              context.read<HomeCubit>().loadHomeData();
            }
          },
        ),
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsSavedSuccess) {
              context.read<HomeCubit>().loadHomeData();
            }
          },
        ),
      ],
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: BalancesLoadingShimmer());
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().loadHomeData();
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  BuildGreetingCard(settings: state.settings),
                  const SizedBox(height: 16),
                  const BuildFinancialYearCard(),
                  const SizedBox(height: 16),

                  const BuildAlertBanners(
                    alertType: AlertType.info,
                    message:
                        'تنبيه: اقترب موعد نهاية السنة المالية، يرجى تسوية رصيد إجازاتك.',
                  ),
                  const SizedBox(height: 16),
                  BuildBalancesSection(
                    balance: state.balance,
                    settings: state.settings,
                  ),
                  const SizedBox(height: 24),
                  BuildCurrentMonthLeaves(leaves: state.currentMonthLeaves),
                  const SizedBox(height: 80),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
