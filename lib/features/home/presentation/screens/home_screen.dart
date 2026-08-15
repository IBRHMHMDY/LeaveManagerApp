// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/home/presentation/widgets/home_header.dart';
import 'package:leave_manager/features/home/presentation/widgets/upcoming_holiday_card.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_cubit.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_state.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/features/home/presentation/widgets/rest_stats_card.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/home/presentation/widgets/balances_loading_shimmer.dart';
import 'package:leave_manager/features/home/presentation/widgets/leaves_balances_section.dart';
import 'package:leave_manager/features/home/presentation/widgets/current_month_leaves_section.dart';
import 'package:leave_manager/features/home/presentation/widgets/welcome_card.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:leave_manager/features/home/presentation/widgets/alert_banners.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

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
    return Scaffold(
      appBar: const AppAppBar(
        customTitle: HomeHeader(),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: AppShareButton(buttonType: ShareButtonType.icon),
          ),
        ],
      ),
      body: MultiBlocListener(
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
          BlocListener<RestAllowancesBloc, RestAllowancesState>(
            listener: (context, state) {
              if (state is RestAllowanceActionSuccess) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  children: [
                    // Welcome Employee
                    WelcomeCard(
                      employeeName: state.settings.employeeName,
                      role: state.settings.jobTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Upcoming Holiday
                    BlocBuilder<HolidaysCubit, HolidaysState>(
                      builder: (context, holidayState) {
                        if (holidayState is HolidaysLoaded) {
                          return Column(
                            children: [
                              UpcomingHolidayCard(
                                upcomingHoliday: holidayState.upcomingHoliday,
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                          );
                        }
                        return const Column(
                          children: [
                            UpcomingHolidayCard(upcomingHoliday: null),
                            SizedBox(height: AppSpacing.md),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Alert Banner
                    const AlertBanners(
                      alertType: AlertType.info,
                      message:
                          'تنبيه: اقترب موعد نهاية السنة المالية، يرجى تسوية رصيد إجازاتك.',
                    ),
                    LeavesBalancesSection(
                      balance: state.balance,
                      settings: state.settings,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    BlocBuilder<RestAllowancesBloc, RestAllowancesState>(
                      builder: (context, restState) {
                        if (restState is RestAllowancesLoaded) {
                          return Column(
                            children: [
                              RestStatsCard(
                                totalAvailableDays: restState.availables,
                                totalConsumedDays: restState.usage,
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    const SizedBox(height: AppSpacing.lg),
                    CurrentMonthLeavesSection(
                      leaves: state.currentMonthLeaves,
                      restAllowances: state.currentMonthRestAllowances,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
