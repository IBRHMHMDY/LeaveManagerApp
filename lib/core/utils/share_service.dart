// lib/core/utils/share_service.dart

import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

/// خدمة مسؤولة عن مشاركة الروابط والنصوص خارج التطبيق
@lazySingleton
class ShareService {
  
  /// مشاركة رابط التطبيق مع نص توضيحي
  Future<void> shareAppLink({
    required String appUrl,
    String? message,
  }) async {
    final String textToShare = message != null ? '$message\n$appUrl' : appUrl;
    
    // استدعاء نافذة المشاركة الأصلية للنظام
    await Share.share(textToShare);
  }
}