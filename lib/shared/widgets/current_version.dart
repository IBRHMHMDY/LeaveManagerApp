import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_cubit.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_state.dart';

class CurrentVersion extends StatelessWidget {
  const CurrentVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppVersionCubit()..fetchVersion(),
      child: const _VersionDisplay(),
    );
  }
}

class _VersionDisplay extends StatelessWidget {
  const _VersionDisplay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppVersionCubit, AppVersionState>(
      builder: (context, state) {
        if (state is AppVersionLoading) {
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.colorScheme.primary,
            ),
          );
        } else if (state is AppVersionLoaded) {
          return Text(
            'الإصدار : ${state.version}',
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}