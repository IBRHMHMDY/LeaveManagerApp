enum LeaveFilter { all, regular, casual, restAllowance }

extension LeaveFilterExtension on LeaveFilter {
  String get label {
    switch (this) {
      case LeaveFilter.all:
        return 'الكل';
      case LeaveFilter.regular:
        return 'اعتيادي';
      case LeaveFilter.casual:
        return 'عارضة';
      case LeaveFilter.restAllowance:
        return 'بدل راحة'; 
    }
  }
}