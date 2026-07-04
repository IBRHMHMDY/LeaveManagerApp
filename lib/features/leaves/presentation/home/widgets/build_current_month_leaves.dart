import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/shared_widgets/custom_leave_card.dart';

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
                return CustomLeaveCard(leave: leave);
              }),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
