import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/features/app_updates/presentation/cubit/app_update_cubit.dart';
import 'package:leave_manager/features/app_updates/presentation/cubit/app_update_state.dart';
import 'package:leave_manager/shared/widgets/displays/app_version_display.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppUpdateCubit>()..fetchVersionOnly(),
      child: BlocBuilder<AppUpdateCubit, AppUpdateState>(
        builder: (context, state) {
          if (state is AppUpdateLoading) {
            return const AppVersionDisplay(version: '', isLoading: true);
          } else if (state is AppVersionLoaded) {
            return AppVersionDisplay(version: state.version);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}