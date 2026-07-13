import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/features/app/presentation/bloc/navigation_cubit.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_bloc.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_state.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart'; // من أجل الملاحة

class BuildRestAllowanceCard extends StatelessWidget {
  const BuildRestAllowanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return BlocBuilder<ExtraWorkBloc, ExtraWorkState>(
      builder: (context, extraWorkState) {
        return BlocBuilder<LeavesBloc, LeavesState>(
          builder: (context, leavesState) {
            if (extraWorkState is ExtraWorkLoaded &&
                leavesState is LeavesLoaded) {
              final totalEarned = extraWorkState.extraWorkDays.length;
              final remaining = leavesState.balance.remainingRestAllowances;
              final consumed = totalEarned - remaining;

              return InkWell(
                onTap: () => context.read<NavigationCubit>().changeTab(
                  selectedIndex: 2, // الانتقال لصفحة بدل الراحة في الشريط السفلي
                  restAllowanceTab: 1, // فتح تبويب العمل الإضافي تلقائياً
                ),
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.restAllowanceColor.withAlpha(
                        isDark ? 30 : 50,
                      ),
                      width: 1.5,
                    ),
                  ),
                  color: isDark
                      ? colorScheme.surface
                      : AppColors.restAllowanceColor.withAlpha(40),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.restAllowanceColor.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.weekend_rounded,
                            color: AppColors.restAllowanceColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ايام العمل الاضافيه',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.restAllowanceColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              totalEarned == 0
                                  ? Text(
                                      'اضغط هنا لتسجيل عمل إضافي',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: totalEarned == 0
                                            ? AppColors.restAllowanceColor
                                                  .withAlpha(150)
                                            : colorScheme.onSurface.withAlpha(
                                                250,
                                              ),
                                        fontWeight: totalEarned == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    )
                                  : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                'الرصيد',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors
                                                      .restAllowanceColor,
                                                ),
                                              ),
                                              Text(
                                                '$totalEarned',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors
                                                      .restAllowanceColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'مستهلك',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: colorScheme.onSurface
                                                      .withAlpha(150),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '$consumed',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors
                                                      .restAllowanceColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'المتبقى',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: colorScheme.onSurface
                                                      .withAlpha(150),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '$remaining',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors
                                                      .restAllowanceColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
