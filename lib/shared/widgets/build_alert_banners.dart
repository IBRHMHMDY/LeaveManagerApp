import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/shared/widgets/custom_alert_banner.dart';

class BuildAlertBanners extends StatelessWidget {
  const BuildAlertBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeavesBloc, LeavesState>(
      builder: (context, state) {
        if (state is LeavesLoaded) {
          List<Widget> alerts = [];
          final currentMonth = DateTime.now().month;
          // إضافة تنبيه معلوماتي (Info)
          if (currentMonth == 6) {
            alerts.add(
              const CustomAlertBanner( 
                message: 'تنبيه: اقترب موعد نهاية السنة المالية، يرجى تسوية رصيد إجازاتك.',
                type: AlertType.info,
              ),
            );
          }
          return Column(children: alerts);
        }
        return const SizedBox.shrink();
      },
    );
  }
}