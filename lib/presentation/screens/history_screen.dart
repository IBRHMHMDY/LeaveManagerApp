import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_type.dart';
import '../../core/constants/app_colors.dart';
import '../blocs/leaves/leaves_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'الكل'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل إجازاتي')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['الكل', 'اعتيادي', 'عارض'].map((filter) {
                return ChoiceChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: BlocBuilder<LeavesBloc, LeavesState>(
              builder: (context, state) {
                if (state is LeavesLoaded) {
                  final filteredLeaves = state.currentYearLeaves.where((leave) {
                    if (_selectedFilter == 'الكل') return true;
                    if (_selectedFilter == 'اعتيادي') return leave.leaveType == LeaveType.regular;
                    return leave.leaveType == LeaveType.casual;
                  }).toList();

                  if (filteredLeaves.isEmpty) {
                    return const Center(child: Text('لا توجد سجلات إجازات مطابقة.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
                      final isRegular = leave.leaveType == LeaveType.regular;
                      final color = isRegular ? AppColors.regularLeaveColor : AppColors.casualLeaveColor;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(width: 12, color: color),
                          title: Text(isRegular ? 'إجازة اعتيادية' : 'إجازة عارضة', 
                                     style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('من: ${leave.startDate.toString().split(' ')[0]} - إلى: ${leave.endDate.toString().split(' ')[0]}'),
                              if (leave.notes != null && leave.notes!.isNotEmpty)
                                Text('ملاحظات: ${leave.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: color.withAlpha(1),
                            child: Text('${leave.daysCount}', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
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