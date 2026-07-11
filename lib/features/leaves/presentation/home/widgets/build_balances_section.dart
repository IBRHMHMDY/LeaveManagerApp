// lib/features/leaves/presentation/home/widgets/build_balances_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';

class BuildBalancesSection extends StatelessWidget {
  const BuildBalancesSection(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<LeavesBloc, LeavesState>(
          builder: (context, leavesState) {
            if (settingsState is SettingsLoaded && leavesState is LeavesLoaded) {
              return Row(
                children: [
                  Expanded(
                    child: _buildCircularIndicator(
                      context,
                      'اعتيادي',
                      leavesState.balance.remainingRegular,
                      settingsState.settings.totalRegularLeaves,
                      AppColors.regularLeaveColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCircularIndicator(
                      context,
                      'عارضة',
                      leavesState.balance.remainingCasual,
                      settingsState.settings.totalCasualLeaves,
                      AppColors.casualLeaveColor,
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget _buildCircularIndicator(
    BuildContext context,
    String title,
    int remaining,
    int total,
    Color color,
  ) {
    double progress = total > 0 ? (remaining / total) : 0;
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    
    return Card(
      // جميع خصائص اللون والظل يتم سحبها الآن تلقائياً من AppTheme
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        // إضافة لمسة خفيفة بلون الإجازة للإطار
        side: BorderSide(
          color: color.withAlpha(isDark ? 80 : 120),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: color.withAlpha(isDark ? 30 : 40),
                    color: color,
                    strokeCap: StrokeCap.round, // Modern rounded stroke
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$remaining',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    Text(
                      '/ $total',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}