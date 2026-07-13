import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_bloc.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_state.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/widgets/custom_extra_work_card.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';

class ExtraWorkView extends StatelessWidget {
  const ExtraWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExtraWorkBloc, ExtraWorkState>(
      listener: (context, state) {
        if (state is ExtraWorkLoaded) {
          context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
        } else if (state is ExtraWorkError) {
          AppNotifications.showError(context, state.message);
        }
      },
      child: BlocBuilder<ExtraWorkBloc, ExtraWorkState>(
        builder: (context, state) {
          if (state is ExtraWorkLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.restAllowanceColor,
              ),
            );
          } else if (state is ExtraWorkLoaded) {
            final days = state.extraWorkDays;
            if (days.isEmpty) {
              return const Center(
                child: Text(
                  'لا يوجد أيام عمل إضافي مسجلة.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              // تم إضافة مسافة سفلية (bottom: 80) لمنع تغطية الزر العائم لآخر عنصر
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 80,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return CustomExtraWorkCard(day: day);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
