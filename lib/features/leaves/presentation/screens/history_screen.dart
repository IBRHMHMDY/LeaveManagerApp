import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/utils/enums/leave_type.dart';
import 'package:vacation_tracker/core/utils/extenstions/leave_filter_extension.dart';
import 'package:vacation_tracker/core/widgets/custom_empty_state.dart';
import 'package:vacation_tracker/core/widgets/custom_leave_card.dart';
import 'package:vacation_tracker/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:vacation_tracker/features/leaves/presentation/widgets/build_filter_chips.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  LeaveFilter _selectedFilter = LeaveFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BuildFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: (newFilter) {
              setState(() {
                _selectedFilter = newFilter;
              });
            },
          ),
          Expanded(
            child: BlocBuilder<LeavesBloc, LeavesState>(
              builder: (context, state) {
                if (state is LeavesLoaded) {
                  final filteredLeaves = state.currentYearLeaves.where((leave) {
                    // الفلترة النظيفة باستخدام Enum
                    if (_selectedFilter == LeaveFilter.all) {
                      return true;
                    }
                    if (_selectedFilter == LeaveFilter.regular) {
                      return leave.leaveType == LeaveType.regular;
                    }
                    return leave.leaveType == LeaveType.casual;
                  }).toList();

                  if (filteredLeaves.isEmpty) {
                    return const CustomEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
                      return CustomLeaveCard(leave: leave);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
