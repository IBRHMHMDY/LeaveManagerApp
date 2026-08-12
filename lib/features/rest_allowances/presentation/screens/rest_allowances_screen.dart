// lib/features/rest_allowances/presentation/screens/rest_allowances_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_state.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowances_card.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_action_buttons.dart';
import 'package:leave_manager/shared/widgets/displays/app_app_bar.dart';
import 'package:leave_manager/shared/widgets/displays/app_empty_state.dart';
import 'package:leave_manager/shared/widgets/inputs/app_segmented_tabs.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

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
    return Scaffold(
      appBar: const AppAppBar(
        title: 'بدلات الراحة',),
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
          if (state is RestAllowancesLoading ||
              state is RestAllowancesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestAllowancesLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // داخل دالة build في شاشة RestAllowancesScreen
                AppSegmentedTabs<bool>(
                  selectedValue: _showAvailables,
                  onChanged: (isAvailable) {
                    setState(() {
                      _showAvailables = isAvailable;
                    });
                  },
                  tabs: [
                    AppTabItem(
                      value: true,
                      label: 'رصيد متاح (${state.availables})',
                    ),
                    AppTabItem(
                      value: false,
                      label: 'رصيد مستهلك (${state.usage})',
                    ),
                  ],
                ),
                Expanded(
                  child: _buildList(
                    _showAvailables ? state.extrawork : state.rest,
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

  Widget _buildList(List<ExtraWorkRecord> extrawork) {
    if (extrawork.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد بيانات',
        content: 'لا توجد سجلات لعرضها هنا.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: extrawork.length,
      itemBuilder: (context, index) {
        return RestAllowancesCard(extrawork: extrawork[index]);
      },
    );
  }
}
