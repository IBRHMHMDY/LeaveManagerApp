// lib/features/layout/presentation/cubit/layout_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'layout_state.dart';

@injectable
class LayoutCubit extends Cubit<LayoutState> {
  DateTime? _lastBackPressTime;

  LayoutCubit() : super(LayoutInitial());

  void handlePopRequest() {
    final now = DateTime.now();
    
    // إذا كانت هذه هي الضغطة الأولى، أو مر أكثر من ثانيتين على الضغطة السابقة
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      
      _lastBackPressTime = now;
      emit(const LayoutExitWarning('اضغط مرة أخرى للخروج'));
      
      // إعادة الحالة إلى Initial لتجنب تكرار التنبيهات
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) emit(LayoutInitial());
      });
    } else {
      // إذا تم الضغط مرتين متتاليتين خلال ثانيتين
      emit(LayoutExitApproved());
    }
  }
}