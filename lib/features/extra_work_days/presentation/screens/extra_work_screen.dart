import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/features/extra_work_days/presentation/bloc/extra_work_bloc.dart';
import 'package:leave_manager/features/extra_work_days/presentation/bloc/extra_work_state.dart';
import 'package:leave_manager/features/extra_work_days/presentation/widgets/add_extra_work_bottom_sheet.dart';
import 'package:leave_manager/features/extra_work_days/presentation/widgets/custom_extra_work_card.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';


class ExtraWorkScreen extends StatelessWidget {
  const ExtraWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExtraWorkBloc, ExtraWorkState>(
      listener: (context, state) {
        // عند نجاح أي عملية (إضافة/حذف) يجب تحديث الرصيد الرئيسي للإجازات
        if (state is ExtraWorkLoaded) {
          context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
        } else if (state is ExtraWorkError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سجل أيام العمل الإضافية', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.restAllowanceColor.withAlpha(10),
          foregroundColor: AppColors.restAllowanceColor,
          elevation: 0,
        ),
        body: BlocBuilder<ExtraWorkBloc, ExtraWorkState>(
          builder: (context, state) {
            if (state is ExtraWorkLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.restAllowanceColor));
            } else if (state is ExtraWorkLoaded) {
              final days = state.extraWorkDays;

              if (days.isEmpty) {
                return const Center(
                  child: Text(
                    'لم تقم بتسجيل أي أيام عمل إضافية بعد.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const AddExtraWorkBottomSheet(),
            );
          },
          backgroundColor: AppColors.restAllowanceColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('إضافة يوم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}