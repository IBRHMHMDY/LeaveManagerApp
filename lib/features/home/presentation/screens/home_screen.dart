// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/upcoming_holiday_card.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_cubit.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_state.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                children: [
                  BuildGreetingCard(settings: state.settings),
                  SizedBox(height: 16.h),
                  const BuildFinancialYearCard(),
                  SizedBox(height: 16.h),
                  BlocBuilder<HolidaysCubit, HolidaysState>(
                    builder: (context, holidayState) {
                      if (holidayState is HolidaysLoaded) {
                        return Column(
                          children: [
                            UpcomingHolidayCard(
                              upcomingHoliday: holidayState.upcomingHoliday,
                            ),
                            SizedBox(height: 16.h),
                          ],
                        );
                      }
                      // إظهار بطاقة فارغة كعنصر نائب أثناء التحميل
                      return Column(
                        children: [
                          const UpcomingHolidayCard(upcomingHoliday: null),
                          SizedBox(height: 16.h),
                        ],
                      );
                    },
                  ),
                  
                  const BuildAlertBanners(
                    alertType: AlertType.info,
                    message:
                        'تنبيه: اقترب موعد نهاية السنة المالية، يرجى تسوية رصيد إجازاتك.',
                  ),
                 

                  BuildBalancesSection(
                    balance: state.balance,
                    settings: state.settings,
                  ),
                  SizedBox(height: 24.h),

                  BuildCurrentMonthLeaves(leaves: state.currentMonthLeaves),
                  SizedBox(
                    height: 80.h,
                  ), // مساحة أسفل القائمة لمنع التداخل مع NavigationBar
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
