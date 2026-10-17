// lib/features/notifications/data/datasources/notifications_local_data_source.dart
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

/// العقد البرمجي لمصدر البيانات المحلي للإشعارات والتخزين الآمن للتوكن.
abstract class NotificationsLocalDataSource {
  /// حفظ إشعار جديد في قاعدة بيانات Drift (مع تجنب التكرار إذا كان remoteId موجوداً).
  Future<void> insertNotification(NotificationsTableCompanion companion);

  /// جلب كافة الإشعارات مرتبة تنازلياً حسب وقت الاستلام.
  Future<List<NotificationModel>> getAllNotifications();

  /// حساب عدد الإشعارات غير المقروءة.
  Future<int> getUnreadNotificationsCount();

  /// تحديث حالة إشعار محدد إلى مقروء.
  Future<void> markNotificationAsRead(int id);

  /// تحديث حالة جميع الإشعارات إلى مقروءة.
  Future<void> markAllNotificationsAsRead();

  /// حذف إشعار محدد بواسطة معرفه المحلي [id].
  Future<void> deleteNotification(int id);

  /// مسح جميع سجلات الإشعارات من قاعدة البيانات.
  Future<void> clearAllNotifications();

  /// قراءة آخر رمز FCM تمت مزامنته مع الخادم من التخزين الآمن.
  Future<String?> getLastSyncedFcmToken();

  /// حفظ رمز FCM وإصدار التطبيق بعد نجاح المزامنة في التخزين الآمن.
  Future<void> cacheSyncedFcmToken(String token);
}

/// التنفيذ الفعلي لمصدر البيانات المحلي باستخدام [AppDatabase] و [FlutterSecureStorage].
@LazySingleton(as: NotificationsLocalDataSource)
class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;

  static const String _syncedFcmTokenKey = 'secure_last_synced_fcm_token';

  /// منشئ الكلاس يستقبل قاعدة البيانات والتخزين الآمن عبر DI.
  const NotificationsLocalDataSourceImpl(this._db, this._secureStorage);

  @override
  Future<void> insertNotification(
    NotificationsTableCompanion companion,
  ) async {
    try {
      // التحقق من عدم وجود إشعار بنفس الـ remoteId لمنع التكرار
      if (companion.remoteId.present && companion.remoteId.value != null) {
        final remoteIdValue = companion.remoteId.value!;
        final existing = await (_db.select(_db.notificationsTable)
              ..where((tbl) => tbl.remoteId.equals(remoteIdValue))
              ..limit(1))
            .getSingleOrNull();

        if (existing != null) {
          return;
        }
      }

      await _db.into(_db.notificationsTable).insert(companion);
    } catch (e, stackTrace) {
      debugPrint('Insert Notification DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر حفظ الإشعار في قاعدة البيانات.');
    }
  }

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      return await (_db.select(_db.notificationsTable)
            ..orderBy([
              (tbl) => OrderingTerm.desc(tbl.receivedAt),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
          .get();
    } catch (e, stackTrace) {
      debugPrint('Get Notifications DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر تحميل سجل الإشعارات.');
    }
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    try {
      final countExp = _db.notificationsTable.id.count();
      final query = _db.selectOnly(_db.notificationsTable)
        ..addColumns([countExp])
        ..where(_db.notificationsTable.isRead.equals(false));

      final result = await query.map((row) => row.read(countExp)).getSingle();
      return result ?? 0;
    } catch (e, stackTrace) {
      debugPrint('Count Unread Notifications DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر حساب الإشعارات غير المقروءة.');
    }
  }

  @override
  Future<void> markNotificationAsRead(int id) async {
    try {
      await (_db.update(_db.notificationsTable)
            ..where((tbl) => tbl.id.equals(id)))
          .write(const NotificationsTableCompanion(isRead: Value(true)));
    } catch (e, stackTrace) {
      debugPrint('Mark Read DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر تحديث حالة قراءة الإشعار.');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      await (_db.update(_db.notificationsTable)
            ..where((tbl) => tbl.isRead.equals(false)))
          .write(const NotificationsTableCompanion(isRead: Value(true)));
    } catch (e, stackTrace) {
      debugPrint('Mark All Read DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر تحديث جميع الإشعارات كمقروءة.');
    }
  }

  @override
  Future<void> deleteNotification(int id) async {
    try {
      await (_db.delete(_db.notificationsTable)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
    } catch (e, stackTrace) {
      debugPrint('Delete Notification DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر حذف الإشعار.');
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    try {
      await _db.delete(_db.notificationsTable).go();
    } catch (e, stackTrace) {
      debugPrint('Clear All Notifications DB Error: $e\n$stackTrace');
      throw const DatabaseException('تعذر مسح سجل الإشعارات.');
    }
  }

  @override
  Future<String?> getLastSyncedFcmToken() async {
    try {
      return await _secureStorage.read(key: _syncedFcmTokenKey);
    } catch (e, stackTrace) {
      debugPrint('SecureStorage Read Error: $e\n$stackTrace');
      throw const CacheException('تعذر قراءة رمز الإشعارات المحفوظ.');
    }
  }

  @override
  Future<void> cacheSyncedFcmToken(String token) async {
    try {
      await _secureStorage.write(key: _syncedFcmTokenKey, value: token);
    } catch (e, stackTrace) {
      debugPrint('SecureStorage Write Error: $e\n$stackTrace');
      throw const CacheException('تعذر حفظ رمز الإشعارات في التخزين الآمن.');
    }
  }
}