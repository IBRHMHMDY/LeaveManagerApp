import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/presentation/widgets/custom_leave_card.dart';

import '../../domain/entities/leave_type.dart';
import '../../core/constants/app_colors.dart';
import '../blocs/leaves/leaves_bloc.dart';

// 1. استخدام Enum محلي للفلترة لتجنب الأخطاء الإملائية والنصوص الصلبة في المنطق
enum LeaveFilter { all, regular, casual }

extension LeaveFilterExtension on LeaveFilter {
  String get label {
    switch (this) {
      case LeaveFilter.all:
        return 'الكل';
      case LeaveFilter.regular:
        return 'اعتيادي';
      case LeaveFilter.casual:
        return 'عارضة';
    }
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // الاعتماد على الـ Enum بدلاً من الـ String
  LeaveFilter _selectedFilter = LeaveFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دفتر الإجازات'), centerTitle: true),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocBuilder<LeavesBloc, LeavesState>(
              builder: (context, state) {
                if (state is LeavesLoaded) {
                  final filteredLeaves = state.currentYearLeaves.where((leave) {
                    // الفلترة النظيفة باستخدام Enum
                    if (_selectedFilter == LeaveFilter.all)
                    {
                     return true;
                    }
                    if (_selectedFilter == LeaveFilter.regular){
                      return leave.leaveType == LeaveType.regular;
                    }
                    return leave.leaveType == LeaveType.casual;
                  }).toList();

                  if (filteredLeaves.isEmpty) {
                    return _buildEmptyState();
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

  // فصل واجهة الفلاتر لتنظيف دالة الـ build
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: LeaveFilter.values.map((filter) {
          final isSelected = _selectedFilter == filter;
          return ChoiceChip(
            label: Text(
              filter.label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.primaryTeal,
            backgroundColor: Colors.grey.shade200,
            onSelected: (selected) {
              if (selected) setState(() => _selectedFilter = filter);
            },
          );
        }).toList(),
      ),
    );
  }

  // تحسين تجربة المستخدم عند عدم وجود بيانات (Empty State)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إجازات مسجلة في هذا التصنيف.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
