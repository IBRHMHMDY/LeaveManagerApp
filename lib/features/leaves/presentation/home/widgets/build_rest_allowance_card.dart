import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/features/extra_work_days/presentation/bloc/extra_work_bloc.dart';
import 'package:leave_manager/features/extra_work_days/presentation/bloc/extra_work_state.dart';
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
                onTap: () => context.push('/extra-work'),
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
                              Text(
                                totalEarned == 0
                                    ? 'اضغط هنا لتسجيل عمل إضافي'
                                    : 'الرصيد: $totalEarned | مستهلك: $consumed',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: totalEarned == 0
                                      ? AppColors.restAllowanceColor
                                      : colorScheme.onSurface.withAlpha(150),
                                  fontWeight: totalEarned == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (totalEarned > 0) ...[
                              Text(
                                '$remaining',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.restAllowanceColor,
                                ),
                              ),
                              Text(
                                'يوم',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withAlpha(150),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
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
