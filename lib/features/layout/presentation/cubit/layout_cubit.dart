// lib/features/layout/presentation/cubit/layout_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'layout_state.dart';

@injectable
class LayoutCubit extends Cubit<LayoutState> {
  DateTime? _lastBackPressTime;

  LayoutCubit() : super(LayoutInitial());

  /// معالجة طلب الرجوع للخلف (محاولة الخروج من التطبيق)
  void handlePopRequest() {
    final now = DateTime.now();

    // إذا لم تكن هناك نقرة سابقة، أو مر أكثر من ثانيتين على النقرة السابقة
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      emit(const LayoutExitWarning('اضغط مرة أخرى للخروج من التطبيق'));
      
      // إعادة الحالة إلى Initial بصمت لضمان القدرة على إرسال التحذير مجدداً إذا لزم الأمر
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) emit(LayoutInitial());
      });
    } else {
      // السماح بالخروج إذا تم النقر مرتين خلال ثانيتين
      emit(LayoutExitApproved());
    }
  }
}