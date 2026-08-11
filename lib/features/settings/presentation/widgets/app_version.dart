import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_cubit.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_state.dart';
import 'package:leave_manager/shared/widgets/displays/app_version_display.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppVersionCubit()..fetchVersion(),
      child: BlocBuilder<AppVersionCubit, AppVersionState>(
        builder: (context, state) {
          if (state is AppVersionLoading) {
            return const AppVersionDisplay(
              version: '',
              isLoading: true, // سيعرض مؤشر التحميل
            );
          } else if (state is AppVersionLoaded) {
            return AppVersionDisplay(
              version: state.version, // سيعرض رقم الإصدار
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
