// lib/features/rest_allowances/presentation/screens/rest_allowances_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowances_card.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_balance_button.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_header.dart';
import 'package:leave_manager/shared/widgets/displays/app_app_bar.dart';
import 'package:leave_manager/shared/widgets/displays/app_empty_state.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

class RestAllowancesScreen extends StatefulWidget {
  const RestAllowancesScreen({super.key});

  @override
  State<RestAllowancesScreen> createState() => _RestAllowancesScreenState();
}

class _RestAllowancesScreenState extends State<RestAllowancesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestAllowancesBloc>().add(LoadRestAllowancesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(customTitle: RestHeader()),
      body: BlocConsumer<RestAllowancesBloc, RestAllowancesState>(
        listener: (context, state) {
          if (state is RestAllowanceActionSuccess) {
            AppToast.showSuccess(context, state.message);
          } else if (state is RestAllowancesError) {
            AppToast.showError(context, state.message);
          }
        },
        buildWhen: (previous, current) =>
            current is RestAllowancesLoaded || current is RestAllowancesLoading,
        builder: (context, state) {
          if (state is RestAllowancesLoading || state is RestAllowancesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RestAllowancesLoaded) {
            // دمج السجلات المتاحة والمستهلكة وترتيبها تنازلياً حسب تاريخ العمل
            final allRecords = [...state.extrawork, ...state.rest]
              ..sort((a, b) => b.workStartDate.compareTo(a.workStartDate));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildList(allRecords),
                ),
              ],
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const AddBalanceButton(),
    );
  }

  Widget _buildList(List<ExtraWorkRecord> records) {
    if (records.isEmpty) {
      return const AppEmptyState(
        title: 'لا يوجد بدلات راحة',
        content: 'قم بإضافة أيام العمل الإضافية أو العطلات التي عملت بها.',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return RestAllowancesCard(
          key: ValueKey('extrawork_card_${records[index].id}'),
          extrawork: records[index],
        );
      },
    );
  }
}