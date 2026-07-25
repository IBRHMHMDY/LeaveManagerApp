import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowance_stats_card.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowance_tabs.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowance_card.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_action_buttons.dart';
import 'package:leave_manager/shared/widgets/custom_empty_state.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class RestAllowancesScreen extends StatefulWidget {
  const RestAllowancesScreen({super.key});

  @override
  State<RestAllowancesScreen> createState() => _RestAllowancesScreenState();
}

class _RestAllowancesScreenState extends State<RestAllowancesScreen> {
  bool _showEarned = true;

  @override
  void initState() {
    super.initState();
    context.read<RestAllowancesBloc>().add(LoadRestAllowancesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_outlined, color: colorScheme.primary),
                SizedBox(width: 8.w),
                Text(
                  'بدلات الراحة',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocConsumer<RestAllowancesBloc, RestAllowancesState>(
        listener: (context, state) {
          if (state is RestAllowanceActionSuccess) {
            AppToast.showSuccess(context, state.message);
          } else if (state is RestAllowancesError) {
            AppToast.showError(context, state.message);
          }
        },
        buildWhen: (previous, current) => current is RestAllowancesLoaded || current is RestAllowancesLoading,
        builder: (context, state) {
          if (state is RestAllowancesLoading || state is RestAllowancesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestAllowancesLoaded) {
            final listToDisplay = _showEarned ? state.availableAllowances : state.consumedAllowances;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(
                    'هنا يمكنك تسجيل أيام العمل الإضافية أو العطلات الرسمية التي عملت بها لكسب "بدل راحة" واستخدامها لاحقاً كإجازات تعويضية.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colorScheme.onSurface.withAlpha(180),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                RestAllowanceStatsCard(
                  totalAvailable: state.totalAvailable,
                  totalConsumed: state.totalConsumed,
                  totalEarned: state.totalAvailable + state.totalConsumed,
                ),
                RestAllowanceTabs(
                  showEarned: _showEarned,
                  earnedCount: state.availableAllowances.length,
                  consumedCount: state.consumedAllowances.length,
                  onChanged: (isEarned) {
                    setState(() {
                      _showEarned = isEarned;
                    });
                  },
                ),
                Expanded(
                  child: listToDisplay.isEmpty
                      ? const CustomEmptyState(titleEmpty: 'لا يوجد رصيد ايام عمل اضافيه', contentEmpty: 'قم باضافه عمل اضافى لكسب يوم بدل راحه',)
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          itemCount: listToDisplay.length,
                          itemBuilder: (context, index) {
                            return RestAllowanceCard(
                              allowance: listToDisplay[index],
                              isEarnedTab: _showEarned,
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const RestActionButtons(),
    );
  }
}