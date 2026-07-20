import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_state.dart';
import 'package:leave_manager/core/utils/app_info_helper.dart';

// --- Cubit ---
class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit() : super(AppVersionInitial());

  /// استدعاء هذه الدالة عند تهيئة الشاشة لجلب الإصدار
  Future<void> fetchVersion() async {
    emit(AppVersionLoading());
    // جلب البيانات بشكل غير متزامن
    final String version = await AppInfoHelper.getVersionOnly();
    emit(AppVersionLoaded(version: version));
  }
}