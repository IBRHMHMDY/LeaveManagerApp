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