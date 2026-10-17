// lib/core/database/tables/notifications_table.dart
import 'package:drift/drift.dart';

/// جدول تخزين الإشعارات الواردة من نظام AppsNotifiersSystem محلياً.
/// يُولّد كلاس البيانات باسم [NotificationModel] ليتوافق مع معمارية التطبيق.
@DataClassName('NotificationModel')
class NotificationsTable extends Table {
  /// المعرف التلقائي للإشعار في قاعدة البيانات المحلية.
  IntColumn get id => integer().autoIncrement()();

  /// المعرف الفريد للإشعار القادم من الخادم أو FCM Message ID (اختياري لمنع التكرار).
  TextColumn get remoteId => text().nullable()();

  /// عنوان الإشعار.
  TextColumn get title => text()();

  /// نص ومحتوى الإشعار.
  TextColumn get body => text()();

  /// رابط الصورة المرفقة بالإشعار إن وجد.
  TextColumn get imageUrl => text().nullable()();

  /// مسار التوجيه الداخلي (Deep Link) أو الرابط الخارجي عند النقر على الإشعار.
  TextColumn get actionUrl => text().nullable()();

  /// البيانات الإضافية المرفقة مع الإشعار بصيغة JSON String.
  TextColumn get payloadJson => text().nullable()();

  /// حالة قراءة الإشعار (الافتراضي: غير مقروء false).
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  /// تاريخ ووقت استلام الإشعار.
  DateTimeColumn get receivedAt =>
      dateTime().withDefault(currentDateAndTime)();
}