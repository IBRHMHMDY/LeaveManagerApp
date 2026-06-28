import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:vacation_tracker/core/widgets/custom_alert_banner.dart';

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
          // // إضافة تحذير / خطأ (Error)
          // if (state.balance.remainingRegular <= 3) {
          //   alerts.add(
          //     const CustomAlertBanner(
          //       message: 'تنبيه: رصيد اجازاتك الإعتياديه قارب على النفاذ.',
          //       type: AlertType.warning,
          //     ),
          //   );
          // }else if (state.balance.remainingRegular == 0){
          //   alerts.add(
          //     const CustomAlertBanner(
          //       message: 'تحذير: لقد نفذ رصيد الاجازات الإعتياديه',
          //       type: AlertType.error,
          //     ),
          //   );
          // }
          // if (state.balance.remainingCasual <= 3) {
          //   alerts.add(
          //     const CustomAlertBanner(
          //       message: 'تنبيه: رصيد اجازاتك العارضه قارب على النفاذ.',
          //       type: AlertType.error,
          //     ),
          //   );
          // }else if (state.balance.remainingCasual == 0){
          //   alerts.add(
          //     const CustomAlertBanner(
          //       message: 'تحذير: نفذ رصيد الاجازات العارضه',
          //       type: AlertType.error,
          //     ),
          //   );
          // }
          // if (state.balance.remainingCasual == 0 && state.balance.remainingRegular == 0){
          //   alerts.add(
          //     const CustomAlertBanner(
          //       message: 'تحذير: لقد نفذ رصيدكم',
          //       type: AlertType.error,
          //     ),
          //   );
          // }
          return Column(children: alerts);
        }
        return const SizedBox.shrink();
      },
    );
  }
}