import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/constants/app_colors.dart';
import 'package:vacation_tracker/presentation/blocs/leaves/leaves_bloc.dart';
import 'package:vacation_tracker/presentation/blocs/settings/settings_bloc.dart';

class BuildBalancesSection extends StatelessWidget {
  const BuildBalancesSection(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<LeavesBloc, LeavesState>(
          builder: (context, leavesState) {
            if (settingsState is SettingsLoaded &&
                leavesState is LeavesLoaded) {
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

    return Card(
      elevation: 4, // Enhanced elevation for better depth
      shadowColor: color.withAlpha(
        50,
      ),
      color: AppColors.lightSurface, // Colored shadow matching the leave type
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
          strokeAlign: BorderSide.strokeAlignCenter,
          style: BorderStyle.solid,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ), // Smoother radius
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110, // Slightly larger
                  height: 110,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    // FIX: Changed withAlpha(2) to withAlpha(25)
                    backgroundColor: color.withAlpha(50),
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
                      'من $total',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
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
