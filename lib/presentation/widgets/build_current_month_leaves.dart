import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/presentation/blocs/leaves/leaves_bloc.dart';
import 'package:vacation_tracker/presentation/widgets/custom_leave_card.dart';

class BuildCurrentMonthLeaves extends StatelessWidget {
  const BuildCurrentMonthLeaves(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeavesBloc, LeavesState>(
      builder: (context, state) {
        if (state is LeavesLoaded) {
          final currentMonth = DateTime.now().month;
          final currentYear = DateTime.now().year;

          // تصفية الإجازات لتشمل إجازات هذا الشهر فقط
          final monthLeaves = state.currentYearLeaves
              .where(
                (leave) =>
                    leave.startDate.month == currentMonth &&
                    leave.startDate.year == currentYear,
              )
              .toList();

          if (monthLeaves.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجازات الشهر الحالي',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...monthLeaves.map((leave) {
                // final isRegular = leave.leaveType == LeaveType.regular;
                // final color = isRegular
                //     ? AppColors.regularLeaveColor
                //     : AppColors.casualLeaveColor;
                return CustomLeaveCard(leave: leave);
                // return Card(
                //   margin: const EdgeInsets.only(bottom: 8),
                //   child: ListTile(
                //     leading: Container(
                //       width: 4,
                //       color: color,
                //     ),
                //     title: Text(isRegular ? 'اعتيادية' : 'عارضة', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                //     subtitle: Text('${leave.startDate.toFormattedDate()} إلى ${leave.endDate.toFormattedDate()}'),
                //     trailing: Text(
                //       '${leave.daysCount} أيام',
                //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                //     ),
                //   ),
                // );
              }),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
