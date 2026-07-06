// lib/core/utils/share_util.dart
import 'package:share_plus/share_plus.dart';

class ShareUtil {
  /// دالة معزولة لمشاركة رابط أو نص الترحيب الخاص بالتطبيق
  static Future<void> shareApplication() async {
    const String shareMessage = 
        'قم بتحميل تطبيق "مدير الإجازات" لتنظيم أرصدة إجازاتك السنوية والعارضة بكل ذكاء وسهولة! 📱✨';
        
    // استدعاء الحزمة الخارجية من مكان واحد موحد
    await Share.share(shareMessage);
  }
}