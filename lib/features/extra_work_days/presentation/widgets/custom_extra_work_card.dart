import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../domain/entities/extra_work_day_entity.dart';
import '../bloc/extra_work_bloc.dart';
import '../bloc/extra_work_events.dart';

class CustomExtraWorkCard extends StatelessWidget {
  final ExtraWorkDay day;

  const CustomExtraWorkCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const color = AppColors.restAllowanceColor;

    return Dismissible(
      key: ValueKey(day.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(20), // توافق مع ثيم التطبيق
        ),
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من رغبتك في حذف يوم العمل الإضافي هذا؟ سيتم خصمه من رصيد بدلات الراحة المكتسبة.'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('إلغاء', style: TextStyle(color: colorScheme.onSurface)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('نعم، حذف'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<ExtraWorkBloc>().add(DeleteExtraWorkDayEvent(day.id));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            // الشريط الجانبي الملون
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: color),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // شارة توضح النوع
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'عمل إضافي مكتسب',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // التاريخ
                        Row(
                          children: [
                            Icon(Icons.event_available_rounded, size: 16, color: colorScheme.onSurface.withAlpha(150)),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('EEEE، d MMMM yyyy', 'ar').format(day.date),
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        // الملاحظات (تظهر فقط إذا كانت موجودة وبطريقة متناسقة)
                        if (day.notes != null && day.notes!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withAlpha(100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_outline_rounded, size: 14, color: colorScheme.onSurface.withAlpha(150)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${day.notes}',
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withAlpha(200),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // مؤشر إضافة الرصيد (+1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withAlpha(15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '+1',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'يوم',
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(150),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}