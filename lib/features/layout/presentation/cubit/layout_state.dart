// lib/features/layout/presentation/cubit/layout_state.dart
import 'package:equatable/equatable.dart';

abstract class LayoutState extends Equatable {
  const LayoutState();

  @override
  List<Object> get props => [];
}

class LayoutInitial extends LayoutState {}

/// حالة تشير إلى ضرورة عرض تحذير للمستخدم (للنقر مرة أخرى للخروج)
class LayoutExitWarning extends LayoutState {
  final String message;

  const LayoutExitWarning(this.message);

  @override
  List<Object> get props => [message];
}

/// حالة تشير إلى الموافقة على الخروج من التطبيق
class LayoutExitApproved extends LayoutState {}