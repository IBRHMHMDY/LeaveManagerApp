import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// يمثل حالة التنقل الحالية في التطبيق
class NavigationState extends Equatable {
  /// التبويب السفلي النشط (0 للرئيسية، 2 لبدل الراحة... إلخ)
  final int selectedIndex;
  /// التبويب الداخلي لشاشة بدل الراحة (0 للعمل الإضافي، 1 للعطلات)
  final int restAllowanceTab;

  const NavigationState({
    required this.selectedIndex,
    this.restAllowanceTab = 0,
  });

  @override
  List<Object> get props => [selectedIndex, restAllowanceTab];
}

/// الكيوبيت المسؤول عن تغيير وتبديل شاشات التنقل والتبويبات الداخلية
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(selectedIndex: 0));

  /// تغيير التبويب النشط مع إمكانية تحديد التبويب الداخلي لشاشة بدل الراحة
  void changeTab({required int selectedIndex, int restAllowanceTab = 0}) {
    emit(NavigationState(
      selectedIndex: selectedIndex,
      restAllowanceTab: restAllowanceTab,
    ));
  }
}