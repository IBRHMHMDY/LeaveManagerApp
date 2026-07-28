// lib/features/rest_allowances/presentation/screens/rest_allowances_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowance_tabs.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/extra_work_card.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_action_buttons.dart';
import 'package:leave_manager/shared/widgets/custom_empty_state.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class RestAllowancesScreen extends StatefulWidget {
  const RestAllowancesScreen({super.key});

  @override
  State<RestAllowancesScreen> createState() => _RestAllowancesScreenState();
}

class _RestAllowancesScreenState extends State<RestAllowancesScreen> {
  bool _showAvailables = true; 

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_outlined, color: colorScheme.primary),
            SizedBox(width: 8.w),
            Text('بدلات الراحة', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RestAllowanceTabs(
                  showAvailables: _showAvailables,
                  availablesCount: state.availables,
                  usageCount: state.usage,
                  onChanged: (isAvailable) {
                    setState(() {
                      _showAvailables = isAvailable;
                    });
                  },
                ),
                Expanded(
                  child: _buildList(_showAvailables ? state.extrawork : state.rest),
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

  Widget _buildList(List<ExtraWorkRecord> records) {
    if (records.isEmpty) {
      return const CustomEmptyState(titleEmpty: 'لا توجد بيانات', contentEmpty: 'لا توجد سجلات لعرضها هنا.');
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return ExtraWorkCard(record: records[index]);
      },
    );
  }
}